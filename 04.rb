#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all
require "json"
require "test/unit/assertions"
require "byebug"

include Test::Unit::Assertions
# The first match makes the card worth one point and each match after the first doubles
# 1 match = 1 point, 2 match = 2 points, 3 match = 4 points, 4 match = 8 points, 5 match = 16 points
class Part1
  class << self
    def extract_numbers(line)
      line.scan(/\d+/).map(&:to_i)
    end

    def execute
      total = 0
      lines = File.read("input.txt").lines

      lines.each_with_index do |line, line_index|
        line = line.split(":")[1]
        winning_cards = extract_numbers(line.split("|")[0])
        my_cards = extract_numbers(line.split("|")[1])

        matches = winning_cards & my_cards
        p line
        p matches

        total += 2**(matches.count - 1) if matches.count.positive?
      end

      p total
    end
  end
end

# So, if you win a copy of card 10 and it has 5 matching numbers, it would then win a copy of the same cards that the original card 10 won: cards 11, 12, 13, 14, and 15
#
class Part2
  class << self
    def extract_numbers(line)
      line.scan(/\d+/).map(&:to_i)
    end

    def execute(lines)
      scratch_cards = Array.new(lines.size, 0)
      lines.each_with_index do |line, line_index|
        winning_cards, my_cards = line.split(":")[1].split("|").map { |part| extract_numbers(part) }
        matches = winning_cards & my_cards
        winnings = matches.count

        scratch_cards[line_index] += 1
        scratch_cards[line_index].times do |_|
          winnings.times { |i| scratch_cards[line_index + (i + 1)] += 1 if scratch_cards[line_index + (i + 1)] }
        end
      end
      scratch_cards.sum
    end
  end
end
total = Part2.execute(File.read("input.txt").lines)
p total
