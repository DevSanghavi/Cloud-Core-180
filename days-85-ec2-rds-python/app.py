import os
import mysql.connector

connection = mysql.connector.connect(
    host=os.environ["DB_HOST"],
    port=3306,
    user=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    database=os.environ["DB_NAME"],
)

cursor = connection.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS visits (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255) NOT NULL)")
cursor.execute("INSERT INTO visits (message) VALUES (%s)", ("Hello from EC2 Python",))
connection.commit()
cursor.execute("SELECT id, message FROM visits ORDER BY id DESC LIMIT 5")

for row in cursor.fetchall():
    print(row)

cursor.close()
connection.close()
