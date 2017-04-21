require "date"


class Task < Post
  def initialize
    super
    @due_date = Time.now
  end

  def load_data(data_hash)
    super(data_hash)
    @due_date = Date.parse(data_hash['due_date'])
  end

  def to_db_hash
    return super.merge(
                    {
                       'text' => @text,
                       'due_date' => @due_date.to_s
                    }
    )
  end

  def read_from_console
    puts "Что надо сдеать?"
    @text = STDIN.gets.chomp

    puts "К какому числу выполнить задачу? ДД.ММ.ГГГГ"
    input = STDIN.gets.chomp

    @due_date = Date.parse(input)

    #ЗДЕСЬ МОЖНО УЖЕ РАЙЗИТЬ ЭРРОР ПРО НЕ ТОТ ФОРМАТ ВРЕМЕНИ
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H%:%M:%s")} \n\r"
    deadline = "Крайний срок: #{@due_date}"
    [deadline, @text, time_string]
  end
end