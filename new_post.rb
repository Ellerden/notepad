require_relative "lib/post.rb"
require_relative "lib/link.rb"
require_relative "lib/memo.rb"
require_relative "lib/task.rb"

puts "Привет! Я - блокнот"
puts "Что ты хочешь записать?"

choices = Post.post_types.keys
choice = -1

until choice >=0 && choice < choices.size

  choices.each_with_index { |type, index|
  puts "\t #{index}. #{type}" }


  choice = STDIN.gets.chomp.to_i
end

entry = Post.post_create(choices[choice])

entry.read_from_console

id = entry.save_to_db
puts "Запись сохранена, id = #{id}"
