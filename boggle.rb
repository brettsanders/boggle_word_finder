require 'colorize'
require_relative 'boggle_word_finder'
require_relative 'boggle_generator'

board = BoggleBoardSmarter.new
board = board.shake!

board.each do |row|
  puts row.join(' ')
end

# board = BoggleBoardSmarter.new
# board = board.shake!

# puts board

@words.each do |word|
  boggle_game = Board.new(board)
  boggle_game.include?("#{word}")
end

Board.number_of_words
puts
Board.found_words_solution

