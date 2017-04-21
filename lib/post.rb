require 'sqlite3'

class Post

  SQLITE_DB_FILE = 'notepad.sqlite'

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link}
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

  def self.post_create(type)
    post_types[type].new
  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  def save_to_db
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true
    post_hash = to_db_hash

    # INSERT INTO posts (type, created_at, text) VALUES (?, ?, ?), ["Memo", "2017-04-21", "eeebe"]
    db.execute("INSERT INTO posts (#{post_hash.keys.join(', ')}) VALUES (#{('?,' * post_hash.size).chomp(',')})",
    post_hash.values)


    insert_row_id = db.last_insert_row_id

    db.close
    insert_row_id
  end

  def self.find(limit, type, id)
    db = SQLite3::Database.open(SQLITE_DB_FILE)

    # конкретная запись
    if !id.nil?
      db.results_as_hash = true
      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
      result = result[0] if result.is_a? Array
      db.close

      if result.empty?
        puts "Такой id не найден в базе"
        return nil
      else
        post = post_create(result['type'])
        post.load_data(result)
        return post
      end
    else
    #вернуть таблицу записей
      db.results_as_hash = false
      query = "SELECT rowid, * FROM posts "
      #тут именованный плейсхолдер :type
      query += "WHERE type = :type " unless type.nil?
      query += "ORDER by rowid DESC "
      query += "LIMIT :limit " unless limit.nil?

      statement = db.prepare(query)

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close
      db.close

      return result
    end
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

  def read_from_console
#todo
  end

  def to_strings
#todo
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    for item in to_strings do
      file.puts(item)
    end
    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_$H-%M-%S.txt")
    return current_path + "/" +file_name
  end


end