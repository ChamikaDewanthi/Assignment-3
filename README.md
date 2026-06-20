# CrossDB Frontend System

This project demonstrates the implementation of a multi-database system using PostgreSQL (SQL) and MongoDB (NoSQL). The objective is to explore how different types of databases with similar structures can be accessed and managed through a single Python-based frontend.

The system consists of multiple databases, each containing tables or collections populated with dummy data. Both PostgreSQL and MongoDB databases are designed to have similar structures, where approximately half of the data is replicated across the databases, while the remaining data is uniquely distributed (fragmented).

A Python frontend is developed to interact with these databases. The program provides functionality for:

* Selecting and connecting to a specific database (PostgreSQL or MongoDB)
* Retrieving and displaying data from the selected database
* Updating existing data within the database

The application serves as a unified interface for database operations, allowing users to work with different database systems without needing to understand their internal differences.

This project highlights key database management concepts such as multi-database access, data replication, and data fragmentation, while also demonstrating practical integration between relational and non-relational databases using Python.

## How to Run

Restore PostgreSQL Database

1. Open pgAdmin 4.
2. Create a new database named "Aurora_America".
3. Open the Query Tool.
4. Select restore on the database.
5. Select format as plain.
6. Select the "schema.backup" file from "db_restore/postgres/" path.
7. Click restore

Restore MongoDB Collections

1. Open MongoDB Compass.
2. Click import connections
3. Select source file "compass-connections.json" from "db_restore/mongo/" path.
4. Click import.

Execute source code

1. Download the folder.
2. Open the folder in Visual Studio Code.
3. Execute the requirements.txt to install dependencies.
4. Run app.py.
5. Open a browser and navigate to "http://localhost:5000".
 
