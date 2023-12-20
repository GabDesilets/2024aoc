#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

# from weakest to strongest
cards = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse
card_strengths = cards.each_with_index.to_h
card_strengths.transform_values! { |v| v + 1 }

hands =
  File
    .read("input.txt")
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

def strongest_hands(hands, card_strengths)
  hands.sort_by { |hand| hand[0].chars.map { |char| card_strengths[char] } }
end

hands.each do |hand|
  cards = hand[0]
  card_counts = cards.chars.tally
  max_count = card_counts.values.max

  case max_count
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
  hand_categories[category] << hand
end

hand_categories.each { |category, hands| puts "#{category}: #{hands.size}" }

ranks = hand_categories.values.flat_map { |hands| strongest_hands(hands, card_strengths) }

p ranks.each_with_index.reduce(0) { |acc, (hand, index)| acc += hand[1] * (index + 1) }
