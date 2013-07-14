class BoggleBoardSmarter
  def initialize
    @alphabet = ("A".."Z").to_a
    # @alphabet[17-1] = "Qu" 
    #  @alphabet.map! do |element| 
    #   element == "Qu" ? element : element + " "
    # end
    @alphabet.find
    @die_index = (1..25).to_a
    @final_board = []
    dice = Array.new(16,Array.new(6, "")).flatten!.map!{|element| element = @alphabet[rand(@alphabet.size-1)]}
    @dice = dice.each_slice(6).to_a
    @board = Array.new(4,Array.new(4, ""))
  end

  def shake!
    die_index = 0
    @board.flatten!
    @board.each_with_index{|element, index| @final_board << @dice[index][rand(6-1)]}    
    @final_board = @final_board.each_slice(4).to_a
  end

  def to_s
    @final_board.each do |column| 
       p "#{column[0]} #{column[1]} #{column[2]} #{column[3].rstrip}"
    end
  end
end

# test = BoggleBoardSmarter.new
# test.shake!
# puts test


