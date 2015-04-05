def match_float(str)
  str.match(/^-?\d+(\.\d+|)$/)
end

def not_valid_input
  puts "Not a valid input, please enter again."
  puts ""
end

num1 = 0
num2 = 0

loop do
  puts "Enter your first number:"
  input1 = gets.chomp
  puts ""
  if match_float(input1)
    num1 = input1.to_f
    break
  end
  not_valid_input
end


loop do
  puts "Enter your second number:"
  input2 = gets.chomp
  puts ""
  if match_float(input2)
    num2 = input2.to_f
    break
  end
  not_valid_input
end

choices = "1) add 2) minus 3) multiply"
choices += " 4) divide" if num2 != 0
choice = ""

loop do

  puts "Which operate do you want to perform?"
  puts choices
  choice = gets.chomp
  puts ""

  break if %w(1 2 3 4).include? choice
  not_valid_input
end

if choice == '1'
  result = num1 + num2
elsif choice == '2'
  result = num1 - num2
elsif choice == '3'
  result = num1 * num2
else 
  result = num1 / num2
end

puts "Your result is #{result}"
puts ""
