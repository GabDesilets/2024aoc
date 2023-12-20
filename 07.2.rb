#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

# from weakest to strongest
cards = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse
card_strengths = cards.each_with_index.to_h
card_strengths.transform_values! { |v| v + 1 }
path = "input.txt"
hands =
  File
    .read(path)
    .split("\n")
    .map do |line|
      bid = line.split(" ")
      [bid[0], bid[1].to_i]
    end

hand_categories = {
  highcards: [],
  onepair: [],
  twopair: [],
  threeofakind: [],
  fullhouse: [],
  fourofakind: [],
  fiveofakind: [],
}
joker_hand_lookup = {
  "5" => :fiveofakind,
  "14" => :fiveofakind,
  "23" => :fiveofakind,
  "113" => :fourofakind,
  "122J" => :fourofakind,
  "122" => :fullhouse,
  "1112" => :threeofakind,
  "11111" => :onepair,
}

def strongest_hands(hands, card_strengths)
  hands.sort_by { |hand| hand[0].chars.map { |char| card_strengths[char] } }
end

def _category(card_counts, count)
  case count
  when 5
    category = :fiveofakind
  when 4
    category = :fourofakind
  when 3
    category = card_counts.values.count(2) == 1 ? :fullhouse : :threeofakind
  when 2
    category = card_counts.values.count(2) == 2 ? :twopair : :onepair
  else
    category = :highcards
  end
end

hands.each do |hand|
  cards = hand[0]
  card_counts = cards.chars.tally.values
  sorted_card = card_counts.sort.join

  card_counts = cards.chars.tally
  max_joker_count = card_counts["J"] || 0
  max_count = card_counts.values.max
  category = _category(card_counts, max_count)
  if max_joker_count > 0
    if max_joker_count == 2 && category == :twopair
      category = joker_hand_lookup["#{sorted_card}J"]
    else
      category = joker_hand_lookup[sorted_card]
    end
  end
  hand_categories[category] << hand
end

#hand_categories.each { |category, hands| puts "#{category} : #{hands.size}" }
#p hand_categories[:fullhouse]
p hand_categories
ranks = hand_categories.values.flat_map { |hands| strongest_hands(hands, card_strengths) }
p ranks.each_with_index.reduce(0) { |acc, (hand, index)| acc += hand[1] * (index + 1) }
