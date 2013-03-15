# --------------------- DB -----------------------
if window.openDatabase
  #Create the database the parameters are 1. the database name 2.version number 3. a description 4. the size of the database (in bytes) 1024 x 1024 = 1MB
  mydb = openDatabase("spanish_verbs_db", "0.1", "Spanish verbs", 4 * 1024 * 1024)
  
  #create the logs table using SQL for the database using a transaction
  # time: timestamp since 1970
  # properties:
  #   action, features, sentences
  mydb.transaction (t) ->
    t.executeSql "CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY ASC, properties TEXT, time INTEGER)"

else
  alert "WebSQL is not supported by your browser!"


resultsFromResultSet = (resultSet) ->
    i = 0
    r = []
    while i < resultSet.rows.length
        r.push(resultSet.rows.item(i))
        i++
    return r

#function to get the list of cars from the database
showLogs = (setResults) ->
    #Get all the cars from the database with a select statement, set outputCarList as the callback function 
    # for the executeSql command
    mydb.transaction (t) ->
      t.executeSql "SELECT * FROM logs order by time", [],  (transaction, results) ->
            setResults(resultsFromResultSet(results))
            
#function to add the car to the database
spanishLog = (properties, timestamp, setResults) ->
      mydb.transaction (t) ->
        t.executeSql "INSERT INTO logs (properties, time) VALUES (?, ?)", [properties, timestamp]
        showLogs(setResults)

define("db", {spanishLog: spanishLog, showLogs: showLogs, resultsFromResultSet: resultsFromResultSet})
