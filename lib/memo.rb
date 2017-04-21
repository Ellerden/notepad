class Memo < Post

  def to_db_hash
    super.merge('text' => @text.join('\n\r'))
  end

  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text'].split('\n\r')
  end

  def read_from_console
    puts "Новая заметка - до слова end"
    @text = []
    line = nil
    while line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H%:%M:%s")} \n \n"
    return @text.unshift(time_string)
  end

end