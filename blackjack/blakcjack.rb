# encoding: UTF-8
require 'pry'

# black jack
#
# make a deck of cards(maybe four deck?)
# set player's token amount
# ask for bets
# deal two cards to both player and dealer
# show two cards of the player and one card of the dealer
# check if dealer has blackjack
#   if yes, player loses and go to next round
# ask player for choices(hit, stand)
#   if hit, 
#     deal one new card to player, show it on screen
#     check if player is busted
#       if yes, player loses and go to next round
#       if not, ask player to make choice again
#   if stand
#     computer make a choice(hit, stand)
#     if hit
#       deal one new card to dealer(computer), show it on screen
#       check if dealer(computer) is busted
#         if yes, player wins and go to next round
#         if not, computer make another choice
#     if stand
#	reveal the hidden card and compare player and computers hands' value
#	if equal
#	  it a tie
#	if computer is bigger
#	  player loses and loses his money
#	if player is bigger
#	  player wins and gained same amount of his bets

# oh, dear... look what I've found
# http://en.wikipedia.org/wiki/Playing_cards_in_Unicode
# But it is actually quite useless...

def dealer_says(sth)
  puts "=> #{sth}"
end

def show_card(card,type = "image") #
  suit = card[0]
  value = card[1]
  case value
  when 1
    type == "text" ? value = "Ace" : value = "A"
  when 11
    type == "text" ? value = "Jack" : value = "J"
  when 12
    type == "text" ? value = "Queen" : value = "Q"
  when 13
    type == "text" ? value = "King" : value = "K"
  end

  if type == "text"
    "#{value} of #{SUITS[suit][0]}"
  elsif type == "image"
    "#{SUITS[suit][1]}#{value}"
  end
end

def cards_to_str_arr(cards)
  cards.map{|card| "🂠 #{show_card(card)}"}
end

def draw_status(dealer_cards,player_cards,hide_first_dealer_card = true)
  system "clear"
  dealer_hands = cards_to_str_arr(dealer_cards)
  dealer_hands[0] = "🂠 ??" if hide_first_dealer_card
  player_hands = cards_to_str_arr(player_cards)
  puts "   Dealer hands: #{dealer_hands.join(" | ")}"
  puts 
  puts 
  puts "    Your  hands: #{player_hands.join(" | ")}"
end

def winner?(dealer_cards,player_cards)
  dealer_points = count_points(dealer_cards)
  player_points = count_points(player_cards)
  case dealer_points <=> player_points
  when 1
    "dealer"
  when 0
    "push"
  when -1
    "player"
  end
end

def busted?(cards)
  count_points(cards) > 21
end

def count_points(cards)
  aces = 0
  points = cards.inject(0) do |sum, card|
    if card[1] == 1
      aces += 1
      sum + 1
    elsif card[1].between?(11,13)
      sum + 10
    else
      sum + card[1]
    end
  end
  aces.times do |n|
    points += 10 unless (points + 10) > 21
  end
  points
end

def dealer_hit_or_stand?(dealer_cards)
  if count_points(dealer_cards) < 17
    'h'
  else
    's'
  end
end

SUITS = {'s' => ['spade',"♠"], 'h' => ["heart","♥"], 'd' => ["diamond","♦"], 'c' => ["club","♣"]}
VALUES = Array(1..13)

# [[s,1],[s,2]....,[h,1],...[c,13]]
ALL_CARDS = SUITS.keys.product(VALUES) 

deck = ALL_CARDS * 4 
deck.shuffle!

system "clear"
dealer_says "Welcome to the Great Casino, what is your name?"
player_name = gets.chomp

dealer_says "Hello, #{player_name}. How much money do you have with you?"

player_money = 0
loop do
  player_input = gets.chomp
  if player_input.match(/\d+/)
    player_money = player_input.to_i
    dealer_says "Great, exchanging your money to token. Please wait...(press enter to continue)"
    gets
    break
  else
    sentences = ["That is not a decent way to talk about your money. Please say again.",
		 "Pardon?", "Sorry, sir. I didn't catch you.", "How much?", "Excuse me?"]
    dealer_says sentences.sample
  end
end

begin # A round
  system "clear"
  dealer_says "Please put your bets. You now have #{player_money} dollars with you"
  bets = 0
  loop do
    puts "Put your bets:" 
    player_input = gets.chomp
    if (player_input.match(/\d+/) && player_input.to_i.between?(1,player_money))
      bets = player_input.to_i
      player_money -= bets
      break
    end
    dealer_says "That is not a valid amount. You have #{player_money} dollars"
  end

  system "clear"
  dealer_cards = []
  player_cards = []
  winner = nil

  2.times do |i|
    dealer_cards << deck.pop
    player_cards << deck.pop
  end

  begin
    draw_status(dealer_cards,player_cards,true)
    # check dealer black jack
    if (dealer_cards[1][1].between?(10,13) || dealer_cards[1][1] == 1)
      if count_points(dealer_cards) == 21
	draw_status(dealer_cards,player_cards,false)
	dealer_says "Dealer has a blackjack! (press enter to continue)"
	gets
	winner = winner?(dealer_cards,player_cards)
	break
      end
    end
    dealer_says "You bet #{bets} this round, and you have #{player_money} dollars left"
    begin
      dealer_says "Would you wish to hit, or stand? (h/s)"
      player_action = gets.chomp
    end until (player_action.downcase == 'h' || player_action.downcase == 's')

    if player_action == 'h'
      player_cards << deck.pop
      winner = "dealer" if busted?(player_cards)
    elsif player_action == 's'
      begin
	dealer_action = dealer_hit_or_stand?(dealer_cards)
	dealer_says "Let me think....(press enter to continue)"
	gets
	if dealer_action == 'h'
	  dealer_cards << deck.pop
	  draw_status(dealer_cards,player_cards,true)
	  winner = "player" if busted?(dealer_cards)
	elsif dealer_action == 's'
	  winner = winner?(dealer_cards,player_cards)
	end 
      end until winner
    end # end if player_action
  end until winner

  draw_status(dealer_cards,player_cards,false)
  case winner
  when "push"
    dealer_says "It's a push! You can have your bets back."
    player_money += bets
  when "dealer"
    dealer_says "Dealer won! You lose your bets."
  when "player"
    dealer_says "You won! You can have double bets back."
    player_money += bets * 2
  end
  
  puts "Next round?(y/n)" if player_money > 0
end until player_money <= 0 || gets.chomp.downcase != 'y'

if player_money <= 0
  dealer_says "You've lost all your money. Get out of here!"
else
  dealer_says "Adios!"
end

