require 'pry'

# Making a tic tac toe game
#
# pseudo code:
#
# draw a board
#
# loop do
#   player pick an empty slot
#   redraw the board
#   check if player wins
#   computer pick an empty slot
#   redraw the board
#   check if computer wins
# end until a winner or there is no more empty slot

def draw_board(b)
  system "clear"
  puts 
  puts " #{b[0]} | #{b[1]} | #{b[2]} "
  puts "-----------"
  puts " #{b[3]} | #{b[4]} | #{b[5]} "
  puts "-----------"
  puts " #{b[6]} | #{b[7]} | #{b[8]} "
  puts 
end

def empty_slots(b)
  Array(0..8).select{|i| b[i] == ' '}
end

def valid_choice?(choice,b)
  return false if choice.match(/[1-9]/).nil?
  slot = choice.to_i - 1
  return empty_slots(b).include? slot
end

def computer_make_choice(b)
  # We can implement AI later
  empty_slots(b).sample
end

# return nil if no winner
def who_is_winner(b)
  winner = nil
  winning_case = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  winning_case.each do |c|
    if ((b[c[0]] == 'o' || b[c[0]] == 'x') && b[c[0]] == b[c[1]] && b[c[0]] == b[c[2]])
      winner = b[c[0]]
    end
  end
  winner
end

# loop for main game
begin
  board = Array.new(9,' ')
  draw_board(board)

  # loop for players taking turns
  begin
    begin
      puts "Please select an empty slot#{empty_slots(board).map{|n| n+1}.inspect}: "
      player_choice = gets.chomp
    end until valid_choice?(player_choice,board)
    board[player_choice.to_i - 1] = 'o'
    draw_board(board)
    winner = who_is_winner(board)
    break if winner

    #puts "Computer is making a choice..."
    #sleep(2)
    computer_choice = computer_make_choice(board)
    board[computer_choice] = 'x'
    draw_board(board)
    winner = who_is_winner(board)
    break if winner
  end until empty_slots(board).size == 0

  case winner
  when nil
    puts "It is a tie!"
  when 'o'
    puts "You win!"
  when 'x'
    puts "Computer wins!"
  end

  puts "Play again?(y/n)"
end while gets.chomp == 'y'
