#Data Processing
import pandas as pd
#Security
from getpass import getpass
#SQL
import psycopg2
import psycopg2.extras as extras 

# Class which can acces the database containing my user data
class DatabaseTerminalProcessor:
    # Initialize with a password, this will only need to be entered once when the class is created rather than each time a query is called
    def __init__(self):
        print('input db password')
        self.db_password = getpass()
        
    def open(self):
        self.conn = psycopg2.connect(database = "melodybox_db",
                                     user = "postgres",
                                     password = self.db_password,
                                     host = "localhost",
                                     port = "5432"
                                    )

    def close(self):
        self.conn.close()
  
    def query(self, query):
        # Returns a dataframe of the query result
        cursor = self.conn.cursor() 
        df_query_result = 0
        try:
            cursor.execute(query)
            query_result = cursor.fetchall()
            col_names = [desc[0] for desc in cursor.description]
            df_query_result = pd.DataFrame(data=query_result, columns=col_names)
        except (Exception, psycopg2.DatabaseError) as error: 
            print("Error: %s" % error) 
            cursor.close() 
        cursor.close()
        return df_query_result
        
    def execute_values(self, df, table): 
        # Prep Data
        tuples = [tuple(x) for x in df.to_numpy()] 
        cols = ','.join(list(df.columns)) 
        # SQL query to execute 
        query = "INSERT INTO %s(%s) VALUES %%s" % (table, cols) 
        cursor = self.conn.cursor() 
        # Execute
        try: 
            extras.execute_values(cursor, query, tuples) 
            self.conn.commit() 
        except (Exception, psycopg2.DatabaseError) as error: 
            print("Error: %s" % error) 
            self.conn.rollback() 
            cursor.close() 
            return 1
        print("the dataframe is inserted") 
        cursor.close()