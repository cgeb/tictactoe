WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  board = {}
  (1..9).each {|position| board[position] = ' '}
  board
end

def draw_board(board)
  system 'clear'
  puts " #{board[1]} | #{board[2]} | #{board[3]} "
  puts "------------"
  puts " #{board[4]} | #{board[5]} | #{board[6]} "
  puts "------------"
  puts " #{board[7]} | #{board[8]} | #{board[9]} "
end

def player_picks_square(board)
  begin
    puts "Pick a square (1-9):"
    position = gets.chomp.to_i
    valid_choice = true
    unless position.between?(1,9)
      puts "Please choose a number between 1 and 9!"
      valid_choice = false
    end
    if position.between?(1,9) && board[position] != ' '
      puts "That square has already been chosen!"
      valid_choice = false
    end 
  end until valid_choice
  board[position] = 'X'

end

def empty_positions(board)
  board.select {|_, value| value == ' '}.keys
end

def two_in_a_row(lines_hash, marker)
  if lines_hash.values.count(marker) == 2
    lines_hash.select{|key, value| value == ' '}.keys.first
  else
    false
  end
end

def computer_picks_square(board)
  position = false
  winning_move = false

  WINNING_LINES.each do |line|
    position = two_in_a_row({line[0] => board[line[0]], line[1] => board[line[1]], line[2] => board[line[2]]}, 'O')
    if position
      winning_move = true
      break
    end
  end

  if winning_move == false
    WINNING_LINES.each do |line|
      position = two_in_a_row({line[0] => board[line[0]], line[1] => board[line[1]], line[2] => board[line[2]]}, 'X')
      break if position
    end
  end

  position = empty_positions(board).sample unless position
  
  board[position] = 'O'
end

def check_winner(lines, board)
  lines.each do |line|
    if board[line[0]] == 'X' && board[line[1]] == 'X' && board[line[2]] == 'X'
      return "Player"
    elsif board[line[0]] == 'O' && board[line[1]] == 'O' && board[line[2]] == 'O'
      return "Computer"
    end
  end
  nil
end

begin
  game_board = initialize_board
  draw_board(game_board)

  begin
    player_picks_square(game_board)
    winner = check_winner(WINNING_LINES, game_board)
    draw_board(game_board)
    break if winner
    computer_picks_square(game_board)
    draw_board(game_board)
    winner = check_winner(WINNING_LINES, game_board)
  end until winner || empty_positions(game_board).empty?

  if winner
    puts "#{winner} wins!"
  else
    puts "It's a tie!"
  end

  puts "Play again? Type 'y' if you want to play again."
  continue_playing = gets.chomp.downcase

end while continue_playing == 'y'

puts "Good bye"