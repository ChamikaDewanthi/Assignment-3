import pymongo
import psycopg
import shlex
import pandas as pd
from collections import OrderedDict
import json

# postgres DB Connection
postgres_db = psycopg.connect(host="localhost", port="5432", dbname="Aurora_America", user="postgres", password="admin")
cursor = postgres_db.cursor()
postgres_tables = cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ").fetchall()
postgres_table_count = len(postgres_tables)

# mongo DB Connection
mongo_connection = pymongo.MongoClient("mongodb://localhost:27017")
mongo_db_asia = mongo_connection["Aurora_Asia"] 
mongo_db_europe = mongo_connection["Aurora_Europe"] 
mongo_collections_asia = mongo_db_asia.list_collection_names()
mongo_collections_europe = mongo_db_europe.list_collection_names()

# Function to send list of tables based on selected database
def get_tables(db_type):
    if db_type == 'mongo_asia':
        return mongo_collections_asia
    if db_type == 'mongo_europe':
        return mongo_collections_europe
    elif db_type == 'postgres_america':
        return postgres_tables
    return []

# Function to perform operation
def perform_operation(db_type, table, operation, query):
    if operation == 'print':
        if db_type == 'mongo_asia' or db_type == 'mongo_europe':
            results = get_mongo_table(db_type, table)
        elif db_type == 'postgres_america':
            results = get_postgres_table(table)       
        return results
    elif operation == 'query':
        if db_type == 'mongo_asia' or db_type == 'mongo_europe':
            results = mongo_query_handler(db_type, query)
        elif db_type == 'postgres_america':
            results = postgres_query_handler(query)       
        return results
    elif operation == 'update':
        if db_type == 'mongo_asia' or db_type == 'mongo_europe':
            results = mongo_update_handler(db_type, query)
        elif db_type == 'postgres_america':
            results = postgres_update_handler(query)       
        return results
    return

# Function to send list of data from mongodb table
def get_mongo_table(db_type, table):
    if db_type == 'mongo_asia':
        collection = mongo_db_asia[mongo_collections_asia[int(table)]]
    elif db_type == 'mongo_europe':
        collection = mongo_db_europe[mongo_collections_europe[int(table)]]
    #collection = mongo_db[mongo_collections[int(table)]]
    data = collection.find({}, {"_id":0})
    results = list(sort_columns(data))
    return results

# Function to send list of data from postgres table
def get_postgres_table(table):
    # Build query to fetch all data
    table = postgres_tables[int(table)]
    SQL_query = "SELECT * FROM " + table[0] + ";"
    # Fetch data
    cursor = postgres_db.cursor()
    cursor.execute(SQL_query)
    results = cursor.fetchall()
    # Format results to return with column headings
    column_names = [desc[0] for desc in cursor.description]
    data_frame = pd.DataFrame(results, columns=column_names)
    result_list = data_frame.to_dict(orient="records")
    cursor.close()
    return result_list

# Function to get results for a query on mongodb table
def mongo_query_handler(db_type, query):
    try:
        # Split query to seperate output attributes, collection and where conditions
        split_query = shlex.split(query.replace(",",""))
        # Validate for a select query
        if split_query[0].lower() != "select":
            return "This operation can be used only for select queries"
        index_from = 0
        index_where = 0
        i = 0
        for word in split_query:
            if word.lower() == "from":
                index_from = i
            if word.lower() == "where":
                index_where = i
            i += 1
        output_attributes = split_query[1:index_from]
        if output_attributes[0] == "*":
            output_attributes = {}
        # Set mongo collection name
        collection = split_query[index_from + 1].lower()
        if db_type == 'mongo_asia':
            mongo_collection = mongo_db_asia[collection]
        elif db_type == 'mongo_europe':
            mongo_collection = mongo_db_europe[collection]
        if index_where != 0:
            where_conditions = split_query[index_where + 1:]
            # Convert where condition values to correct datatype
            data_type = get_attribute_datatype(mongo_collection, str(where_conditions[0]))
            converted_value = cast_mongo_value(data_type, where_conditions[2])
            filter_condition = {'$match':{str(where_conditions[0]):converted_value}}
        else:
            where_conditions = ""
        mongo_output = {"$project":{"_id":0}}
        for item in output_attributes:
            mongo_output["$project"][item] = 1
        # Fetch data
        if where_conditions != "":
            data = mongo_collection.aggregate([filter_condition, mongo_output])
        else:
            data = mongo_collection.aggregate([{'$match': {}}, mongo_output])
        results = list(sort_columns(data))
    except:
        results = "Invalid query"
    return results

# Function to get results for a query on postgres table
def postgres_query_handler(query):
    try:
        # Validate for a select query
        if shlex.split(query)[0].lower() != "select":
            return "This operation can be used only for select queries"
        # Fetch data
        cursor = postgres_db.cursor()
        cursor.execute(query)
        data = cursor.fetchall()
        # Format results to return with column headings
        column_names = [desc[0] for desc in cursor.description]
        data_frame = pd.DataFrame(data, columns=column_names)
        results = data_frame.to_dict(orient="records")
    except:
        postgres_db.rollback()
        results = "Invalid query"
    cursor.close()
    return results

# Function to update data in mongodb table
def mongo_update_handler(db_type, query):
    try:
        # Split query to seperate update statements, collection and where conditions
        split_query = shlex.split(query.replace(",",""))
        # Validate for a update query
        if split_query[0].lower() != "update":
            return "This operation can be used only for update queries"
        index_set = 0
        index_where = 0
        i = 0
        for word in split_query:
            if word.lower() == "set":
                index_set = i
            if word.lower() == "where":
                index_where = i
            i += 1
        update_statements = split_query[index_set + 1:index_where]
        # Set mongo collection name
        collection = split_query[index_set - 1].lower()
        if db_type == 'mongo_asia':
            mongo_collection = mongo_db_asia[collection]
        elif db_type == 'mongo_europe':
            mongo_collection = mongo_db_europe[collection]
        if index_where != 0:
            where_conditions = split_query[index_where + 1:]
            # Convert where condition values to correct datatype
            data_type = get_attribute_datatype(mongo_collection, str(where_conditions[0]))
            converted_value = cast_mongo_value(data_type, where_conditions[2])
            filter_list = {str(where_conditions[0]):converted_value}
        else:
            filter_list = {}
        # Build a list of update statements
        update_list = []
        j = 0
        for item in update_statements:
            if item == "=":
                update_list.append({"$set":{str(update_statements[j-1]):str(update_statements[j+1])}})
            j += 1
        # Update data
        for update in update_list:
            mongo_collection.update_many(filter_list, update)
        # Fetch updated rows
        mongo_output = {"_id":0}
        data = mongo_collection.find(filter_list, mongo_output)
        results = list(sort_columns(data))
        return results
    except:
        results = "Invalid query"
    return results

# Function to update data in postgres table
def postgres_update_handler(query):
    try:
        # Validate for a update query
        if shlex.split(query)[0].lower() != "update":
            return "This operation can be used only for update queries"
        # Execute Query
        cursor = postgres_db.cursor()
        cursor.execute(query)
        postgres_db.commit()
        # Build the query to fetch updated rows
        query.lower()
        split_query = query.split("where")
        split_parts = split_query[0].split(" ")
        if len(split_query) > 0:
            where_condition = split_query[1]
            fetch_query = "SELECT * FROM " + split_parts[1] + " where" + where_condition + ";"
        else:
            fetch_query = "SELECT * FROM " + split_parts[1] + ";"
        # Fetch updated rows
        cursor.execute(fetch_query)
        data = cursor.fetchall()
        # Format results to return with column headings
        column_names = [desc[0] for desc in cursor.description]
        data_frame = pd.DataFrame(data, columns=column_names)
        results = data_frame.to_dict(orient="records")
    except:
        postgres_db.rollback()
        results = "Invalid query"
    cursor.close()
    return results

# Function to get the datatype of an attribute from database table
def get_attribute_datatype(table, attribute):
    sample = table.find_one()
    if not sample:
        return
    else:
        sample_data = {key: type(val) for key, val in sample.items()}
        if attribute in sample_data:
            return sample_data[attribute]
        return

# Function to convert a value to the desired datatype
def cast_mongo_value(python_type, value):
    if python_type == int:
        return int(value)
    if python_type == float:
        return float(value)
    if python_type == bool:
        return value.lower() == "true"
    return value

# Function to preserve column order as table
def sort_columns(data):
    ordered_data = []
    for doc in data:
        ordered_doc = OrderedDict()
        for key in doc:
            ordered_doc[key] = doc[key]
        ordered_data.append(ordered_doc)
    return ordered_data