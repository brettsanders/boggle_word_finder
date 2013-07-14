require 'colorize'


@words = []
File.open('words.txt').each { |word| @words << word.chomp }

class Board
  attr_reader :board, :word
  @@bro = 0
  @@found_words_solution = []
  def initialize(board)
    @board = board
    @letter_positions_hash = {}
    @word = nil
    @word_coordinate_data = []
    @all_coordinate_possibilities_for_word = nil
  end

  def self.number_of_words
    puts "There are this many number of words bro:"
    p @@bro
  end

  def self.found_words_solution
    puts "Here are the words found:"
    p @@found_words_solution
  end

  def include?(word)
    @word = word 
    make_hash_initial_hash_for_letters 
    fill_in_hash_with_letter_coordinates
    combine_hash_into_array_for_location_possibilities
    generate_all_coordinate_possiblities_for_word_with_duplicates.size
    remove_duplicates_from_coordinate_possibilities.size
    valid_letter_connections_in_possible_sets
    hilight_word_on_board
  end  
 
  def make_hash_initial_hash_for_letters 
    split_word = word.split('') 
    split_word.each do |letter|
      @letter_positions_hash[letter] = []
    end
    @letter_positions_hash
  end 

  def fill_in_hash_with_letter_coordinates
    @letter_positions_hash.each do |letter_key,coordinates_array|  
      @board.each_with_index do |row,row_index|
        row.each_with_index do |letter_in_row,column_index|   
          if letter_in_row == letter_key.upcase   
            coordinates_for_letter = [] 
            coordinates_for_letter << row_index << column_index  
            @letter_positions_hash[letter_key] << coordinates_for_letter
          end
        end
      end
    end
    @letter_positions_hash
  end

  def combine_hash_into_array_for_location_possibilities
    @word.split(//).each do |letter|
      @word_coordinate_data << @letter_positions_hash[letter]
    end
    @word_coordinate_data
  end

  def generate_all_coordinate_possiblities_for_word_with_duplicates
    @all_coordinate_possibilities_for_word = @word_coordinate_data.first.product(*@word_coordinate_data[1..-1]).map.to_a
  end

  def remove_duplicates_from_coordinate_possibilities
    @all_coordinate_possibilities_for_word.delete_if {|row| row.size != row.uniq.size}
  end

  def valid_move?(current_position,next_position)
    #                               rows                                            columns
    return true if ( next_position[0] == current_position[0] -1 ) && ( next_position[1] == current_position[1] -1 ) # NW
    return true if ( next_position[0] == current_position[0] -1 ) && ( next_position[1] == current_position[1]    ) # N
    return true if ( next_position[0] == current_position[0] -1 ) && ( next_position[1] == current_position[1] +1 ) # NE
    return true if ( next_position[0] == current_position[0]    ) && ( next_position[1] == current_position[1] +1 ) # E
    return true if ( next_position[0] == current_position[0] +1 ) && ( next_position[1] == current_position[1] +1 ) # SE
    return true if ( next_position[0] == current_position[0] +1 ) && ( next_position[1] == current_position[1]    ) # S
    return true if ( next_position[0] == current_position[0] +1 ) && ( next_position[1] == current_position[1] -1 ) # SW
    return true if ( next_position[0] == current_position[0]    ) && ( next_position[1] == current_position[1] -1 ) # W

    false
  end

  def valid_letter_connections_in_possible_sets
    
    @all_coordinate_possibilities_for_word.delete_if do |row|
      
      final_spot_to_check_from = row.size - 2
      value = false

      (0..final_spot_to_check_from).each do |num|
        if valid_move?(row[num],row[num+1]) == false
          value = true
        end
      end

      value
    end
    @all_coordinate_possibilities_for_word
  end

  def hilight_word_on_board
    # just return words
    # puts "#{word} has #{@all_coordinate_possibilities_for_word.size} solutions" if @all_coordinate_possibilities_for_word.size > 0 

    if @all_coordinate_possibilities_for_word.size > 0
      puts "#{word} has #{@all_coordinate_possibilities_for_word.size} solutions"
      @@found_words_solution << @word
      @all_coordinate_possibilities_for_word.each_with_index do |solution,index|
        @@bro += 1
        puts "solution #{index+1}"
      
        board_clone = Marshal.load(Marshal.dump(@board))

        solution.each do |possibility|  
          board_clone[possibility[0]][possibility[1]] = board_clone[possibility[0]][possibility[1]].magenta.on_green
        end

        board_clone.each do |row|
          puts row.join(' ')
        end
        puts
      end
    end
  end


  # def hilight_word_on_board
  #   system('clear')
  #   puts "there are #{@all_coordinate_possibilities_for_word.size} solutions for " + "#{@word}".magenta
  #   puts "given this board: "
  #   puts

  #   @board.each do |row|
  #     puts row.join(' ')
  #   end
  #   # sleep(8.0)

  #   system('clear')

  #   @all_coordinate_possibilities_for_word.each_with_index do |solution,index|
  #     puts "solution #{index+1}"
  #     # sleep(2.0)
  #     system('clear')

  #     board_clone = Marshal.load(Marshal.dump(@board))

  #     solution.each do |possibility|
  #       # board_clone = Marshal.load(Marshal.dump(@board))
        
  #       board_clone[possibility[0]][possibility[1]] = board_clone[possibility[0]][possibility[1]].magenta

  #       board_clone.each do |row|
  #         puts row.join(' ')
  #       end

  #       # sleep(0.5)
  #       system('clear')
  #     end

  #     board_clone.each do |row|
  #       puts row.join(' ')
  #     end

  #     # sleep(2)
  #     system('clear')

  #   end
  #   @board.each do |row|
  #     puts row.join(' ')
  #   end
  # end

end 


# second_board = [
# ['E','P','Q','R'],
# ['P','L','W','M'],
# ['Q','A','P','L'],
# ['X','P','Z','E'] ]

# boggle = Board.new(second_board)
# boggle.include?("apple")



ate = [
['A','T','R','E'],
['E','J','Z','E'],
['S','C','P','T'],
['H','M','O','E'] ]

# boggle = Board.new(ate)
# boggle.include?("ATE")


# puts

# puts "finding coordinates for 'discombobulating'"
# discombobulating_board = [
# ['D','I','S','C'],
# ['O','B','M','O'],
# ['B','U','L','A'],
# ['G','N','I','T']
# ]

# boggle = Board.new(discombobulating_board)
# boggle.include?("discombobulating")



# micah_sherman = [
# ['M','I','S','R'],
# ['C','A','E','M'],
# ['H','H','A','A'],
# ['S','X','I','N']
# ]

# boggle = Board.new(micah_sherman)
# boggle.include?("micahsherman")



# puts "finding coordinates for 'discombobulating'"
# dogg_board = [
# ['D','I','S','C'],
# ['O','B','M','O'],
# ['G','U','L','A'],
# ['G','N','I','T']
# ]

# boggle = Board.new(dogg_board)
# boggle.include?("dogg")




# first_board = [
# ['A','P','Q','R'],
# ['P','L','W','M'],
# ['F','T','D','L'],
# ['A','P','P','E'] ]


# boggle = Board.new(first_board)
# boggle.include?("apple")

# second_board = [
# ['A','P','Q','R'],
# ['P','L','W','M'],
# ['A','T','D','L'],
# ['Q','P','P','E'] ]

# boggle = Board.new(second_board)
# boggle.include?("apple")




# step 1 : 
# get the position [row,column] for each letter in the word on the board
# store as a hash of arrays of coordinate arrays.
#
# letter_positions = {
# "A" => [ [0,0], [3,0] ],
# "P" => [ [0,1], [1,0], [3,1], [3,2] ],
# "L" => [ [1,1], [2,3] ],
# "E" => [ [3,3] ] 
# } 


# step 2 : generate an array of arrays for the word
# Substitute each letter with the array from the hash
# "APPLE" -->
#                                 A                      P                             P                    L               E
# word_coordinate_data = [ [ [0,0],[3,0] ], [ [0,1],[1,0],[3,1],[3,2] ], [ [0,1],[1,0],[3,1],[3,2] ], [ [1,1], [2,3] ], [ [3,3] ] ]
                          # [[[0, 0], [3, 0]], [[0, 1], [1, 0], [3, 1]], [[0, 1], [1, 0], [3, 1]], [[1, 1], [2, 3]], [[3, 3]]]

# step 3: generate all possibilities for the groups from left to right in order
# http://stackoverflow.com/questions/5226895/combine-array-of-array-into-all-possible-combinations-forward-only-in-ruby

# all_coordinate_possibilities_for_word = word_coordinate_data.first.product(*our_data[1..-1]).map.to_a
#
# 64 total possible variations of coordinates including reusing coordinate


# [[[0, 0], [0, 1], [0, 1], [1, 1], [3, 3]],  0
#  [[0, 0], [0, 1], [0, 1], [2, 3], [3, 3]], 
#  [[0, 0], [0, 1], [1, 0], [1, 1], [3, 3]],
#  [[0, 0], [0, 1], [1, 0], [2, 3], [3, 3]], 
#  [[0, 0], [0, 1], [3, 1], [1, 1], [3, 3]], 
#  [[0, 0], [0, 1], [3, 1], [2, 3], [3, 3]], 
#  [[0, 0], [0, 1], [3, 2], [1, 1], [3, 3]], 
#  [[0, 0], [0, 1], [3, 2], [2, 3], [3, 3]], 
#  [[0, 0], [1, 0], [0, 1], [1, 1], [3, 3]], 
#  [[0, 0], [1, 0], [0, 1], [2, 3], [3, 3]], 
#  [[0, 0], [1, 0], [1, 0], [1, 1], [3, 3]], 
#  [[0, 0], [1, 0], [1, 0], [2, 3], [3, 3]], 
#  [[0, 0], [1, 0], [3, 1], [1, 1], [3, 3]], 
#  [[0, 0], [1, 0], [3, 1], [2, 3], [3, 3]], 
#  [[0, 0], [1, 0], [3, 2], [1, 1], [3, 3]], 
#  [[0, 0], [1, 0], [3, 2], [2, 3], [3, 3]], 
#  [[0, 0], [3, 1], [0, 1], [1, 1], [3, 3]], 
#  [[0, 0], [3, 1], [0, 1], [2, 3], [3, 3]], 
#  [[0, 0], [3, 1], [1, 0], [1, 1], [3, 3]], 
#  [[0, 0], [3, 1], [1, 0], [2, 3], [3, 3]], 
#  [[0, 0], [3, 1], [3, 1], [1, 1], [3, 3]], 
#  [[0, 0], [3, 1], [3, 1], [2, 3], [3, 3]], 
#  [[0, 0], [3, 1], [3, 2], [1, 1], [3, 3]], 
#  [[0, 0], [3, 1], [3, 2], [2, 3], [3, 3]], 
#  [[0, 0], [3, 2], [0, 1], [1, 1], [3, 3]], 
#  [[0, 0], [3, 2], [0, 1], [2, 3], [3, 3]], 
#  [[0, 0], [3, 2], [1, 0], [1, 1], [3, 3]], 
#  [[0, 0], [3, 2], [1, 0], [2, 3], [3, 3]], 
#  [[0, 0], [3, 2], [3, 1], [1, 1], [3, 3]], 
#  [[0, 0], [3, 2], [3, 1], [2, 3], [3, 3]], 
#  [[0, 0], [3, 2], [3, 2], [1, 1], [3, 3]], 
#  [[0, 0], [3, 2], [3, 2], [2, 3], [3, 3]], 
#  [[3, 0], [0, 1], [0, 1], [1, 1], [3, 3]], 
#  [[3, 0], [0, 1], [0, 1], [2, 3], [3, 3]], 
#  [[3, 0], [0, 1], [1, 0], [1, 1], [3, 3]], 
#  [[3, 0], [0, 1], [1, 0], [2, 3], [3, 3]], 
#  [[3, 0], [0, 1], [3, 1], [1, 1], [3, 3]], 
#  [[3, 0], [0, 1], [3, 1], [2, 3], [3, 3]], 
#  [[3, 0], [0, 1], [3, 2], [1, 1], [3, 3]], 
#  [[3, 0], [0, 1], [3, 2], [2, 3], [3, 3]], 
#  [[3, 0], [1, 0], [0, 1], [1, 1], [3, 3]], 
#  [[3, 0], [1, 0], [0, 1], [2, 3], [3, 3]], 
#  [[3, 0], [1, 0], [1, 0], [1, 1], [3, 3]], 
#  [[3, 0], [1, 0], [1, 0], [2, 3], [3, 3]], 
#  [[3, 0], [1, 0], [3, 1], [1, 1], [3, 3]], 
#  [[3, 0], [1, 0], [3, 1], [2, 3], [3, 3]], 
#  [[3, 0], [1, 0], [3, 2], [1, 1], [3, 3]], 
#  [[3, 0], [1, 0], [3, 2], [2, 3], [3, 3]], 
#  [[3, 0], [3, 1], [0, 1], [1, 1], [3, 3]], 
#  [[3, 0], [3, 1], [0, 1], [2, 3], [3, 3]], 
#  [[3, 0], [3, 1], [1, 0], [1, 1], [3, 3]], 
#  [[3, 0], [3, 1], [1, 0], [2, 3], [3, 3]], 
#  [[3, 0], [3, 1], [3, 1], [1, 1], [3, 3]], 
#  [[3, 0], [3, 1], [3, 1], [2, 3], [3, 3]], 
#  [[3, 0], [3, 1], [3, 2], [1, 1], [3, 3]], 
#  [[3, 0], [3, 1], [3, 2], [2, 3], [3, 3]], 
#  [[3, 0], [3, 2], [0, 1], [1, 1], [3, 3]], 
#  [[3, 0], [3, 2], [0, 1], [2, 3], [3, 3]], 
#  [[3, 0], [3, 2], [1, 0], [1, 1], [3, 3]], 
#  [[3, 0], [3, 2], [1, 0], [2, 3], [3, 3]], 
#  [[3, 0], [3, 2], [3, 1], [1, 1], [3, 3]], 
#  [[3, 0], [3, 2], [3, 1], [2, 3], [3, 3]], 
#  [[3, 0], [3, 2], [3, 2], [1, 1], [3, 3]], 
#  [[3, 0], [3, 2], [3, 2], [2, 3], [3, 3]]]




# step 4 : scan through all_coordinate_possibilities_for_word
#   eliminate any set that has duplicates, because you CANNOT reuse a letter in boggle
#   "APPLE" only has this problem for the "P"s 
#   other words could have this problem worse
#     ex. "PAPA"
#
#     there were 16 sets with duplicates
#     64 - 16 = 48 remaining sets
#
#         A       P       P       L       E
#      remove 1
#      remove 2
#      [[0, 0], [0, 1], [1, 0], [1, 1], [3, 3]], 
#      [[0, 0], [0, 1], [1, 0], [2, 3], [3, 3]], 
#      [[0, 0], [0, 1], [3, 1], [1, 1], [3, 3]], 
#      [[0, 0], [0, 1], [3, 1], [2, 3], [3, 3]], 
#      [[0, 0], [0, 1], [3, 2], [1, 1], [3, 3]], 
#      [[0, 0], [0, 1], [3, 2], [2, 3], [3, 3]],     
#      [[0, 0], [1, 0], [0, 1], [1, 1], [3, 3]], 
#      [[0, 0], [1, 0], [0, 1], [2, 3], [3, 3]], 
#      remove 3
#      remove 4
#      [[0, 0], [1, 0], [3, 1], [1, 1], [3, 3]], 
#      [[0, 0], [1, 0], [3, 1], [2, 3], [3, 3]], 
#      [[0, 0], [1, 0], [3, 2], [1, 1], [3, 3]], 
#      [[0, 0], [1, 0], [3, 2], [2, 3], [3, 3]], 
#      [[0, 0], [3, 1], [0, 1], [1, 1], [3, 3]], 
#      [[0, 0], [3, 1], [0, 1], [2, 3], [3, 3]], 
#      [[0, 0], [3, 1], [1, 0], [1, 1], [3, 3]], 
#      [[0, 0], [3, 1], [1, 0], [2, 3], [3, 3]], 
#      remove 5
#      remove 6
#      [[0, 0], [3, 1], [3, 2], [1, 1], [3, 3]], 
#      [[0, 0], [3, 1], [3, 2], [2, 3], [3, 3]], 
#      [[0, 0], [3, 2], [0, 1], [1, 1], [3, 3]], 
#      [[0, 0], [3, 2], [0, 1], [2, 3], [3, 3]], 
#      [[0, 0], [3, 2], [1, 0], [1, 1], [3, 3]], 
#      [[0, 0], [3, 2], [1, 0], [2, 3], [3, 3]], 
#      [[0, 0], [3, 2], [3, 1], [1, 1], [3, 3]], 
#      [[0, 0], [3, 2], [3, 1], [2, 3], [3, 3]], 
#      remove 7
#      remove 8
#      remove 9
#      remove 10
#      [[1, 5], [0, 1], [1, 0], [1, 1], [3, 3]], 
#      [[1, 5], [0, 1], [1, 0], [2, 3], [3, 3]], 
#      [[1, 5], [0, 1], [3, 1], [1, 1], [3, 3]], 
#      [[1, 5], [0, 1], [3, 1], [2, 3], [3, 3]], 
#      [[1, 5], [0, 1], [3, 2], [1, 1], [3, 3]], 
#      [[1, 5], [0, 1], [3, 2], [2, 3], [3, 3]], 
#      [[1, 5], [1, 0], [0, 1], [1, 1], [3, 3]], 
#      [[1, 5], [1, 0], [0, 1], [2, 3], [3, 3]], 
#      remove 11
#      remove 12
#      [[1, 5], [1, 0], [3, 1], [1, 1], [3, 3]], 
#      [[1, 5], [1, 0], [3, 1], [2, 3], [3, 3]], 
#      [[1, 5], [1, 0], [3, 2], [1, 1], [3, 3]], 
#      [[1, 5], [1, 0], [3, 2], [2, 3], [3, 3]], 
#      [[1, 5], [3, 1], [0, 1], [1, 1], [3, 3]], 
#      [[1, 5], [3, 1], [0, 1], [2, 3], [3, 3]], 
#      [[1, 5], [3, 1], [1, 0], [1, 1], [3, 3]], 
#      [[1, 5], [3, 1], [1, 0], [2, 3], [3, 3]], 
#      remove 13
#      remove 14
#      [[1, 5], [3, 1], [3, 2], [1, 1], [3, 3]], 
#      [[1, 5], [3, 1], [3, 2], [2, 3], [3, 3]], 
#      [[1, 5], [3, 2], [0, 1], [1, 1], [3, 3]], 
#      [[1, 5], [3, 2], [0, 1], [2, 3], [3, 3]], 
#      [[1, 5], [3, 2], [1, 0], [1, 1], [3, 3]], 
#      [[1, 5], [3, 2], [1, 0], [2, 3], [3, 3]], 
#      [[1, 5], [3, 2], [3, 1], [1, 1], [3, 3]], 
#      [[1, 5], [3, 2], [3, 1], [2, 3], [3, 3]], 
#      remove 15
#      remove 16
#    ]

# step 5 : iterate through each set and check for valid connections between letters
# 
# check if valid? 
#
# valid_letter_connection?(current_coordinate,next_coordinate)
# 
# note : iterate for current_coordinate from 0 to (array.size -1)
#        don't need to check next_coordinate for the last item
# 
# not sure if correct use of 'break'
# but, idea is that if we get to the last element in the set
# it means all the connections were valid up until the last letter
# and we don't need to check the last letter
# so the set is valid and we want to add it to a valid set
# it's possible there are several ways to find a word, which is why we want to store them
# also, would be cool to print out boards with the several ways to find a word highlighted

# @valid_sets = []
# all_sets.each do |set|
#   set.each do |current_coordinate|
#     if current_coordinate == set[-1] # if we're on the last element
#       @valid_sets << set 
#     end
#     next_coordinate = current_coordinate+1
#     break if valid_letter_connection?(current_coordinate, next_coordinate) == false
#   end
# end

# def valid_letter_connection?(current_coordinate,next_coordinate)
#   # set of possible next coordinates
#   possible_next_coordinates_from_current_coordinate = []
#   possible_next_coordinates_from_current_coordinate << # n, ne, e, se, s, sw, w, nw
#   # remove invalid possibilities (row > 3 or column > )
#   if possible_next_coordinates_from_current_coordinate.include?(next_coordinate)
#     return true # could return nothing ..., but true makes method reusable
#   else
#     return false
#   end
# end













