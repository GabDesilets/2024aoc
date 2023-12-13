#!/usr/bin/env ruby
# frozen_string_literal: true

file_content = File.read("example.txt")

total = 0

file_content.each_line do |line|
  _, *sets = line.split(":")
  sets = sets[0].split(";")
  rgb = [0, 0, 0]
  sets.each do |set|
    set
      .scan(/(\d+) (\w+)/)
      .each do |num, color|
        num = num.to_i
        case color
        when "red"
          rgb[0] = num if num > rgb[0]
        when "green"
          rgb[1] = num if num > rgb[1]
        when "blue"
          rgb[2] = num if num > rgb[2]
        end
      end
  end
  total += rgb.reduce(:*)
end

puts total
