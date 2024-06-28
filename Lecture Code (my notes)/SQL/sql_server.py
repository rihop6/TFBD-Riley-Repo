import pymssql

conn = pymssql.connect(server="DESKTOP-EA0E7SH")

# Create a cursor to run queries
cursor = conn.cursor()
cursor.execute("SELECT * FROM INFORMATION_SCHEMA.TABLES")
rows = cursor.fetchall()
[print(row) for row in rows]

# If we are updating/making any changes
# conn.commit()