from __future__ import print_function
import mysql
import mysql.connector
from mysql.connector import errorcode

import datetime

from flask import Flask
import os

print(os.environ)

mysql_user = os.environ.get('MYSQL_USER')
mysql_password = os.environ.get('MYSQL_PASSWORD')
mysql_database = os.environ.get('MYSQL_DATABASE')
mysql_host = os.environ.get('MYSQL_HOST') + ":" + os.environ.get('MYSQL_PORT')

def create_database(cursor, dbname):
    try:
        cursor.execute(
            "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(dbname))
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        exit(1)

def create_tables():
    response_text = []
    cnx = None

    try:
        cnx = mysql.connector.connect(user=mysql_user, password=mysql_password,
                                   host=mysql_host
                                   )
    #
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            response_text.append("Something is wrong with your user name or password")
            return(response_text)
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            response_text.append("Database does not exist")
            return(response_text)
        else:
            response_text.append("Unknown error occurred")
            return(response_text)

    if cnx == None:
        response_text.append("Something went wrong")
        return(response_text)

    # Create tables
    DB_NAME = 'employees'

    TABLES = {}
    TABLES['employees'] = (
     "CREATE TABLE `employees` ("
     "  `emp_no` int(11) NOT NULL AUTO_INCREMENT,"
     "  `birth_date` date NOT NULL,"
     "  `first_name` varchar(14) NOT NULL,"
     "  `last_name` varchar(16) NOT NULL,"
     "  `gender` enum('M','F') NOT NULL,"
     "  `hire_date` date NOT NULL,"
     "  PRIMARY KEY (`emp_no`)"
     ") ENGINE=InnoDB")

    TABLES['departments'] = (
     "CREATE TABLE `departments` ("
     "  `dept_no` char(4) NOT NULL,"
     "  `dept_name` varchar(40) NOT NULL,"
     "  PRIMARY KEY (`dept_no`), UNIQUE KEY `dept_name` (`dept_name`)"
     ") ENGINE=InnoDB")

    TABLES['salaries'] = (
     "CREATE TABLE `salaries` ("
     "  `emp_no` int(11) NOT NULL,"
     "  `salary` int(11) NOT NULL,"
     "  `from_date` date NOT NULL,"
     "  `to_date` date NOT NULL,"
     "  PRIMARY KEY (`emp_no`,`from_date`), KEY `emp_no` (`emp_no`),"
     "  CONSTRAINT `salaries_ibfk_1` FOREIGN KEY (`emp_no`) "
     "     REFERENCES `employees` (`emp_no`) ON DELETE CASCADE"
     ") ENGINE=InnoDB")

    TABLES['dept_emp'] = (
     "CREATE TABLE `dept_emp` ("
     "  `emp_no` int(11) NOT NULL,"
     "  `dept_no` char(4) NOT NULL,"
     "  `from_date` date NOT NULL,"
     "  `to_date` date NOT NULL,"
     "  PRIMARY KEY (`emp_no`,`dept_no`), KEY `emp_no` (`emp_no`),"
     "  KEY `dept_no` (`dept_no`),"
     "  CONSTRAINT `dept_emp_ibfk_1` FOREIGN KEY (`emp_no`) "
     "     REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,"
     "  CONSTRAINT `dept_emp_ibfk_2` FOREIGN KEY (`dept_no`) "
     "     REFERENCES `departments` (`dept_no`) ON DELETE CASCADE"
     ") ENGINE=InnoDB")

    TABLES['dept_manager'] = (
     "  CREATE TABLE `dept_manager` ("
     "  `emp_no` int(11) NOT NULL,"
     "  `dept_no` char(4) NOT NULL,"
     "  `from_date` date NOT NULL,"
     "  `to_date` date NOT NULL,"
     "  PRIMARY KEY (`emp_no`,`dept_no`),"
     "  KEY `emp_no` (`emp_no`),"
     "  KEY `dept_no` (`dept_no`),"
     "  CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) "
     "     REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,"
     "  CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) "
     "     REFERENCES `departments` (`dept_no`) ON DELETE CASCADE"
     ") ENGINE=InnoDB")

    TABLES['titles'] = (
     "CREATE TABLE `titles` ("
     "  `emp_no` int(11) NOT NULL,"
     "  `title` varchar(50) NOT NULL,"
     "  `from_date` date NOT NULL,"
     "  `to_date` date DEFAULT NULL,"
     "  PRIMARY KEY (`emp_no`,`title`,`from_date`), KEY `emp_no` (`emp_no`),"
     "  CONSTRAINT `titles_ibfk_1` FOREIGN KEY (`emp_no`)"
     "     REFERENCES `employees` (`emp_no`) ON DELETE CASCADE"
     ") ENGINE=InnoDB")

    cursor = cnx.cursor()

    try:
        cursor.execute("USE {}".format(DB_NAME))
    except mysql.connector.Error as err:
        response_text.append("Database {} does not exists.".format(DB_NAME))
        if err.errno == errorcode.ER_BAD_DB_ERROR:
            create_database(cursor, DB_NAME)
            response_text.append("Database {} created successfully.".format(DB_NAME))
            cnx.database = DB_NAME
        else:
            response_text.append("Unknown error")
            return(response_text)

    for table_name in TABLES:
        table_description = TABLES[table_name]
        try:
            response_text.append("Creating table {}: ".format(table_name))
            cursor.execute(table_description)
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                response_text.append("already exists.")
            else:
                response_text.append(err.msg)
        else:
            response_text.append("OK")

    cursor.close()
    cnx.close()
    return(response_text)

def insert_data():
     response_text = []

     cnx = mysql.connector.connect(user=mysql_user, password=mysql_password,  host=mysql_host, database=mysql_database)
     cursor = cnx.cursor()

     tomorrow = datetime.datetime.now().date() + datetime.timedelta(days=1)

     add_employee = ("INSERT INTO employees "
                     "(first_name, last_name, hire_date, gender, birth_date) "
                     "VALUES (%s, %s, %s, %s, %s)")
     add_salary = ("INSERT INTO salaries "
                   "(emp_no, salary, from_date, to_date) "
                   "VALUES (%(emp_no)s, %(salary)s, %(from_date)s, %(to_date)s)")

     data_employee = ('Geert', 'Vanderkelen', tomorrow, 'M', datetime.date(1977, 6, 14))

     # Insert new employee
     cursor.execute(add_employee, data_employee)
     emp_no = cursor.lastrowid

     response_text.append("Added new employee record {}".format(emp_no))

     # Insert salary information
     data_salary = {
      'emp_no': emp_no,
      'salary': 50000,
      'from_date': tomorrow,
      'to_date': datetime.date(9999, 1, 1),
     }
     cursor.execute(add_salary, data_salary)

     response_text.append("Added new employee record {}".format(data_salary))

     # Make sure data is committed to the database
     cnx.commit()

     cursor.close()
     cnx.close()

     return(response_text)

def select_data():
     response_text = []
     cnx = mysql.connector.connect(user=mysql_user, password=mysql_password,  host=mysql_host, database=mysql_database)
     cursor = cnx.cursor()

     query = ("SELECT first_name, last_name, hire_date FROM employees "
              "WHERE hire_date BETWEEN %s AND %s")

     hire_start = datetime.date(1999, 1, 1)
     hire_end = datetime.date(2023, 12, 31)

     cursor.execute(query, (hire_start, hire_end))

     for (first_name, last_name, hire_date) in cursor:
        response_text.append("{}, {} was hired on {:%d %b %Y}".format(last_name, first_name, hire_date))

     cursor.close()
     cnx.close()
     return(response_text)


app = Flask(__name__)

@app.route('/')
def default_route():
    return "<center>Hello World! Test App</center>"

@app.route('/create')
def create_route():
    response_text = create_tables()
    return "<center>Created database</center><p>" + "<br>".join(response_text)

@app.route('/insert')
def insert_route():
    response_text = insert_data()
    return "<center>Inserted database</center><p>"+ "<br>".join(response_text)

@app.route('/select')
def select_route():
    response_text = select_data()
    return "<center>Selected database</center><p>" + "<br>".join(response_text)

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=8082)

