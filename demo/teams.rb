require_relative '../lib/db_connection'

DB_FILE = 'demo.db'
SQL_FILE = 'demo.sql'

`rm '#{DB_FILE}'`
`cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'`

EffectiveDoc::DBConnection.open(DB_FILE)

class teams < EffectiveDoc::Base
  has_many :players


end

class Person < EffectiveDoc::Base
  belongs_to :team,

end
