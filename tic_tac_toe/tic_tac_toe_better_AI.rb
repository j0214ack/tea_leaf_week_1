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

def empty_slots(board)
  #Array(0..8).select{|i| board[i] == ' '}
  board.each_with_index.select{|value,index| value == ' ' }.map{|value,index| index}
end

def valid_choice?(choice,board)
  return false if choice.match(/[1-9]/).nil?
  slot = choice.to_i - 1
  return empty_slots(board).include? slot
end

def computer_make_choice(board)
  # There are only 9 slots and it will eventually get fewer, we could check all the slots one by one
  # First find empty slots
  # examine each slot and assign priority

  slots_available = empty_slots(board)
  priorities = {}
  slots_available.each do |slot|
    priorities[s] = assign_priority(slot,board)
  end
  priorities.max_by{|k,v| v}[0]
end

def assign_priority(slot,board)
  # the priority should be
  # 1. make himself complete three-in-a-row
  # 2. block player's two-in-a-row
  #   => Check two-in-a-row, if there's 'x', place it
  #                          elsif there's 'o', block it
  # 3. prevent player's future double two-in-a-row
  # 4. make his own double two-in-a-row
  #    => we can see rows in this way:
  #       non-blocked player's row ( only one 'o' in the row )
  #       non-blocked computer's row ( only one 'x' in the row )
  #
  #       so if the slot is in two or three non-blocked player's row, that is player's future two-in-a-row
  #       vice versa, it will be computer's future two-in-a-row slot
  #
  # ==== below we count each row that the slot is in and add more weight point to the slot ====
  # 5. non-blocked computer rows' slot (4?)
  # 6. if the row is totally empty (3?)
  # 7. middle over corners over sides (2,1,0)

  weight = 0
  all_rows = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  rows_that_have_the_slot = all_rows.select{|r| r.include? s}
  non_blocked_player_rows = 0
  non_blocked_computer_rows = 0
  empty_rows = 0
  
  rows_that_have_the_slot.each do |row|
    two_in_a_row = two_in_the_row?(slot,row,board) 
    # 1. make himself complete three-in-a-row
    if two_in_a_row == 'x'
      weight += 100000

    # 2. block player's two-in-a-row
    elsif two_in_a_row == 'o'
      weight += 10000

    else
      # check if the row is a non-blocked row for step 3,4
      if empty_row?(slot,row,board)
	empty_rows += 1
      elsif non_blocked_row?(slot,row,board) == 'x'
	non_blocked_computer_rows += 1
      elsif non_blocked_row?(slot,row,board) == 'o'
	non_blocked_player_rows += 1
      end
    end
  end # end of rows_that_have_the_slot

  # 3. prevent player's future double two-in-a-row
  # 4. make his own double two-in-a-row
  if non_blocked_player_rows >= 2
    weight += 1000
  elsif non_blocked_computer_rows >= 2
    weight += 100
  end

  # 5. non-blocked computer rows' slot (10 points)
  weight += non_blocked_computer_rows * 10
  # 6. if the row is totally empty (5 points)
  weight += empty_rows * 5
  # 7. middle over corners over sides (2,1,0)
  if slot == 4 # middle
    weight += 2
  elsif [0,2,6,8].include? slot
    weight += 1
  end
  weight
end

def empty_row?(slot,row,board)
  r = row.dup
  r.delete(slot)
  (board[r[0]] == board[r[1]]) && (board[r[0]] == ' ')
end

def non_blocked_row?(slot,row,board)
  r = row.dup.delete(slot)
  if (board[r[0]] == 'x' && board[r[1]] == ' ') || (board[r[0]] == ' ' && board[r[1]] == 'x') 
    'x'
  elsif (board[r[0]] == 'o' && board[r[1]] == ' ') || (board[r[0]] == ' ' && board[r[1]] == 'o') 
    'o'
  else
    nil
  end
end

def two_in_the_row?(slot,row,board)
  r = row.dup
  r.delete(slot)
  if (board[r[0]] == board[r[1]]) && (['x','o'].include? board[r[0]])
    board[r[0]]
  else
    nil
  end
end

# return nil if no winner
def who_is_winner(board)
  winner = nil
  winning_cases = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  winning_cases.each do |c|
    if ((board[c[0]] == 'o' || board[c[0]] == 'x') && 
	board[c[0]] == board[c[1]] && board[c[0]] == board[c[2]])
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
  winner = nil
  loop do
    begin
      puts "Please select an empty slot#{empty_slots(board).map{|n| n+1}.inspect}: "
      player_choice = gets.chomp
    end until valid_choice?(player_choice,board)
    board[player_choice.to_i - 1] = 'o'
    draw_board(board)
    winner = who_is_winner(board)
    break if winner || empty_slots(board).size == 0

    computer_choice = computer_make_choice(board)
    board[computer_choice] = 'x'
    draw_board(board)
    winner = who_is_winner(board)
    break if winner || empty_slots(board).size == 0
  end

  case winner
  when nil
    puts "It is a tie!"
  when 'o'
    puts "You win!"
  when 'x'
    puts "Computer wins!"
  end

  puts "Play again?(y/n)"
end while gets.chomp.downcase == 'y'

