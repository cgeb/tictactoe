WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

class Board
  attr_accessor :data

  def initialize
    @data = {}
    (1..9).each {|position| @data[position] = Square.new(' ')}
  end

  def draw
    system 'clear'
    puts "     |     | "
    puts "  #{@data[1].value}  |  #{@data[2].value}  |  #{@data[3].value} "
    puts "     |     | "
    puts "-----+-----+-----"
    puts "     |     | "
    puts "  #{@data[4].value}  |  #{@data[5].value}  |  #{@data[6].value} "
    puts "     |     | "
    puts "-----+-----+-----"
    puts "     |     | "
    puts "  #{@data[7].value}  |  #{@data[8].value}  |  #{@data[9].value} "
    puts "     |     | "
    puts
  end 

  def mark_square(position, marker)
    @data[position].mark(marker)
  end

  def empty_squares
    @data.select {|_, square| square.value == ' '}.keys
  end

  def all_squares_full?
    empty_squares.size == 0
  end

  def two_squares_in_a_row?(marker)
    position = nil
    WINNING_LINES.each do |line|
      if (@data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == " ") || (@data[line[0]].value == marker && @data[line[1]].value == " " && @data[line[2]].value == marker) || (@data[line[0]].value == " " && @data[line[1]].value == marker && @data[line[2]].value == marker)
        line.each do |number|
          if @data[number].value == " "
            position = number
            position
          end
        end
      end
    end
    position 
  end

  def three_squares_in_a_row?(marker)
    WINNING_LINES.each do |line|
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == marker
    end
    false
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def mark(marker)
    @value = marker
  end

end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    @board = Board.new
    @human = Player.new("Chris", "X")
    @computer = Player.new("Computer", "O")
    @current_player = @human
  end

  def current_player_marks_square
    if @current_player == @human
      begin
        puts "Pick a square (1-9):"
        position = gets.chomp.to_i
      end until @board.empty_squares.include?(position)
    else
      position = @board.two_squares_in_a_row?(@computer.marker)
      if !position
        position = @board.two_squares_in_a_row?(@human.marker)
        if !position
          position = @board.empty_squares.sample
        end
      end
    end
    @board.mark_square(position, @current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def game_finishes
    if @board.three_squares_in_a_row?(@current_player.marker)
      puts "#{@current_player.name} wins!"
      true
    elsif @board.all_squares_full?
      puts "It's a tie!"
      true
    else
      false
    end
  end  

  def play_again?
    begin
      puts "Do you want to play again? Type 'y' to play again."
      continue = gets.chomp.downcase
      if continue == 'y'
        next_game = Game.new.play
      else
        puts "Thanks for playing!"
        false
      end
    end
  end

  def play
    loop do
      current_player_marks_square      
      @board.draw
      if game_finishes
        break if !play_again?
      end
      alternate_player
    end
  end
end


game = Game.new.play