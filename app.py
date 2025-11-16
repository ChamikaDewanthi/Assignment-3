from flask import Flask, render_template, request, jsonify
from db_logic import get_tables, perform_operation

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/get_tables', methods=['POST'])
def get_tables_route():
    data = request.get_json()
    db_type = data.get('db_type')
    tables = get_tables(db_type)
    return jsonify({'tables': tables})

@app.route('/execute', methods=['POST'])
def execute():
    data = request.get_json()
    db_type = data.get('db_type')
    table = data.get('table')
    operation = data.get('operation')
    query = data.get('query', '')
    
    result = perform_operation(db_type, table, operation, query)
    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(debug=True)