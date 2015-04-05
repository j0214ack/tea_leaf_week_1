CHOICES = {'p' => "Paper", 'r' => "Rock", 's' => "Scissors"}
puts "Welcom to #{CHOICES.values.join(", ")}!"

def psr
  begin
    puts "Please take your pick(p/s/r)"
    player_choice = gets.chomp.downcase
  end until CHOICES.has_key? player_choice

  computer_choice = CHOICES.keys.sample
  puts "Your opponent chose #{CHOICES[computer_choice]}!"

  if player_choice == computer_choice
    puts "It's a tie!"

  # p1 wins
  elsif (player_choice == 'p' && computer_choice == 'r') || 
        (player_choice == 's' && computer_choice == 'p') || 
	(player_choice == 'r' && computer_choice == 's')
    puts "You win!"

  # computer wins
  else
    puts "You lose!"
  end
end

begin
  psr
  puts "Play again?(y/n)"
end while gets.chomp.downcase == 'y'

puts "Good bye!"


