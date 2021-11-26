# -----Example Python Program to alter an SQLite Table-----


# import the sqlite3 module

import sqlite3

# Create a connection object

connection = sqlite3.connect("school.db")

# Get a cursor

cursor = connection.cursor()

# # Rename the SQLite Table
#
# renameTable = "ALTER TABLE stud RENAME TO student"
#
# cursor.execute(renameTable)
#
# # Query the SQLite master table

tableQuery = "select * from sqlite_master"

cursor.execute(tableQuery)

tableList = cursor.fetchall()

# Print the updated listed of tables after renaming the stud table

for table in tableList:
    print("Database Object Type: %s" % (table[0]))

    print("Name of the database object: %s" % (table[1]))

    print("Name of the table: %s" % (table[2]))

    print("Root page: %s" % (table[3]))

    print("SQL Statement: %s" % (table[4]))

# close the database connection

connection.close()