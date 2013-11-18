nconf   = require 'nconf'
express = require 'express'
_       = require 'underscore'
colors  = require 'colors'
app     = express()
pg      = require 'pg'

# In case this runs on Heroku
process.env.PWD = process.cwd()

app.configure ->
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

# Load configuration hierarch
if nconf.env().get('NODE_ENV')
  console.log 'Running Production Mode'
  nconf.env().argv().file process.env.PWD  + '/config.json'
else 
  console.log 'Running Dev Mode'.red
  nconf.env().argv().file process.env.PWD  + '/devconfig.json'
#  app.use express.static process.env.PWD  + '/../presentation/app'
#  app.use express.static process.env.PWD  + '/../presentation/.tmp'

# Load PG configurations
pg.defaults.user     = nconf.get 'pg_user'
pg.defaults.password = nconf.get 'pg_pw'
pg.defaults.database = nconf.get 'pg_db'
pg.defaults.host     = nconf.get 'pg_host'
pg.defaults.poolSize = nconf.get 'pg_pool_size' || 10

# TODO : clean this code and proper loggin
app.get '/api/query/en/:query', (req, res)->
  pg.connect (err, client, done) ->
    res.send 500, 'error' if err
    return console.error("could not connect to postgres", err)  if err

    unless req.query.states
      statement = """
                  WITH word_query AS (
                  SELECT word, occurrence, similarity(word, '%s') AS similarity
                    FROM word_table WHERE word % '%s' AND occurrence > 100
                    ORDER BY similarity DESC, occurrence DESC LIMIT 10 
                  )
                  SELECT word
                  FROM word_query
                  LIMIT 10
                  """
    else
      statement = """
                  SELECT word, occurrence, similarity(word, '%s') AS similarity
                    FROM word_table WHERE word % '%s' AND occurrence > 100
                    ORDER BY similarity DESC, occurrence DESC LIMIT 10
                  """

    client.query statement, [req.params.query], (err, result) ->
      done()
      return console.error("error running query", err)  if err
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-With");
      res.send result.rows

app.listen nconf.get "port"
console.log "Running on".green, nconf.get("port")
