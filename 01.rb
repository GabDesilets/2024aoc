#!/usr/bin/env ruby
# frozen_string_literal: true
require "byebug"

total = 0
number_words_to_numbers_map = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}

File.open("input.txt", "r") do |file|
  file.each_line do |line|
    numbers = []
    current_word = ""
    line.chars.each do |char|
      current_word += char
      found = false
      if char =~ /\d/
        numbers << char.to_i
        current_word = ""
      end
      next unless current_word.size >= 3
      number_words_to_numbers_map.keys.each do |key|
        if current_word =~ /#{key}/
          found = true
          numbers << number_words_to_numbers_map[key]
        end
        break if found
      end

      current_word = current_word[-1] if found
    end
    total += "#{numbers[0]}#{numbers[-1]}".to_i
    puts "line: #{line} numbers: #{numbers}"
  end
end
puts total
