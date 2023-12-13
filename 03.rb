#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all
require "byebug"
require "json"
require "test/unit/assertions"

include Test::Unit::Assertions

class Part1
  class << self
    def has_adjacent_symbol?(line, start, stop)
      line[start..stop] =~ /[^0-9.\n]/
    end
    def execute
      lines = File.read("example.txt").lines
      total = 0

      lines.each_with_index do |line, line_index|
        numbers = line.scan(/\d+/)
        number_indexes = line.enum_for(:scan, /\d+/).map { Regexp.last_match.begin(0) }

        numbers.each_with_index do |number, number_index|
          first_char_index = number_indexes[number_index]
          last_char_index = first_char_index + number.size - 1
          start = first_char_index.zero? ? 0 : first_char_index - 1
          stop = last_char_index == line.size - 1 ? last_char_index : last_char_index + 1

          unless has_adjacent_symbol?(line, last_char_index + 1, last_char_index + 1) ||
                   (
                     first_char_index.positive? &&
                       has_adjacent_symbol?(line, first_char_index - 1, first_char_index - 1)
                   ) || (line_index.positive? && has_adjacent_symbol?(lines[line_index - 1], start, stop)) ||
                   (line_index != lines.size - 1 && has_adjacent_symbol?(lines[line_index + 1], start, stop))
            next
          end

          puts "number: #{number} has adjacent symbol"
          total += number.to_i
        end
      end
      puts total
    end
  end
end

# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
class Part2
  class << self
    def get_number_from_index(line, gear_index, direction)
      numbers = line.scan(/\d+/)
      number_indexes_start = line.enum_for(:scan, /\d+/).map { Regexp.last_match.begin(0) }
      number_indexes_ends = line.enum_for(:scan, /\d+/).map { Regexp.last_match.end(0) - 1 }

      number_indexes = direction == :left ? number_indexes_ends : number_indexes_start

      numbers.each_with_index do |number, number_index|
        #debugger if number == "35"
        first_char_index = number_indexes[number_index]
        last_char_index = first_char_index + number.size - 1
        return number.to_i if gear_index >= first_char_index && gear_index <= last_char_index
      end
      return 0
    end
    def execute
      directions_nums = []
      directions_nums_line = []
      lines = File.read("input.txt").lines
      total = 0
      lines.each_with_index do |line, line_index|
        gear_indexes = line.enum_for(:scan, /\*/).map { Regexp.last_match.begin(0) }

        number_indexes = line.enum_for(:scan, /\d+/).map { Regexp.last_match.begin(0) }
        gear_indexes.each do |gear_index|
          directions = {
            up: false, # [0,-1]
            down: false, # [0,1]
            left: false, # [-1,0]
            right: false, # [1,0]
            up_strife_right: false, # [1,1]
            up_strife_left: false, # [1,-1]
            down_strife_right: false, # [-1,1]
            down_strife_left: false, # [-1,-1]
          }
          directions_num = {
            up: 0, # [0,-1]
            down: 0, # [0,1]
            left: 0, # [-1,0]
            right: 0, # [1,0]
            up_strife_right: 0, # [1,1]
            up_strife_left: 0, # [1,-1]
            down_strife_right: 0, # [-1,1]
            down_strife_left: 0, # [-1,-1]
          }

          directions[:left] = line[gear_index - 1] =~ /\d+/ if gear_index.positive?
          directions[:right] = line[gear_index + 1] =~ /\d+/ if gear_index != line.size - 2 # 2 because of \n

          directions_num[:left] = get_number_from_index(line, gear_index - 1, :left) if directions[:left]
          directions_num[:right] = get_number_from_index(line, gear_index + 1, :right) if directions[:right]

          upper_line = lines[line_index - 1]
          down_line = lines[line_index + 1]
          directions[:up] = upper_line[gear_index] =~ /\d+/ if line_index.positive?
          directions[:down] = down_line[gear_index] =~ /\d+/ if line_index != lines.size - 1

          directions_num[:up] = get_number_from_index(upper_line, gear_index, :right) if directions[:up]
          directions_num[:down] = get_number_from_index(down_line, gear_index, :right) if directions[:down]

          #strife checks
          #strie up right and left
          if !directions[:up]
            directions[:up_strife_right] = upper_line[gear_index + 1] =~ /\d+/ if line_index.positive?
            directions[:up_strife_left] = upper_line[gear_index - 1] =~ /\d+/ if line_index.positive?

            directions_num[:up_strife_right] = get_number_from_index(upper_line, gear_index + 1, :right) if directions[
              :up_strife_right
            ]

            directions_num[:up_strife_left] = get_number_from_index(upper_line, gear_index - 1, :left) if directions[
              :up_strife_left
            ]
          end

          if !directions[:down]
            #strife down right and left
            directions[:down_strife_right] = down_line[gear_index + 1] =~ /\d+/ if line_index != lines.size - 1

            directions_num[:down_strife_right] = get_number_from_index(down_line, gear_index + 1, :right) if directions[
              :down_strife_right
            ]
            directions[:down_strife_left] = down_line[gear_index - 1] =~ /\d+/ if line_index != lines.size - 1

            directions_num[:down_strife_left] = get_number_from_index(down_line, gear_index - 1, :left) if directions[
              :down_strife_left
            ]
          end
          directions_nums_line << line_index
          directions_nums << directions_num
        end
      end
      directions_nums.each_with_index do |directions_num, index|
        non_zero_directions = directions_num.values.reject(&:zero?)
        puts "line: #{lines[directions_nums_line[index]]} \n #{JSON.pretty_generate(directions_num)}"
        total += non_zero_directions.reduce(:*) if non_zero_directions.size == 2
      end
      p total
    end
  end
end

Part2.execute
