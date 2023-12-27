#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all
#
path = "input.txt"
history = File.read(path).split("\n")

totals = []
history.each do |line|
  last_to_adds = []
  nums = line.split.map(&:to_i) if ARGV[0] == "1"
  nums = line.split.map(&:to_i).reverse if ARGV[0] == "2"
  next_line = []
  next_line = nums.each_cons(2).map { |x| x[1] - x[0] }
  last_to_adds << next_line.last

  done = false
  while !done
    next_line = next_line.each_cons(2).map { |x| x[1] - x[0] }

    last_to_adds << next_line.last
    done = next_line.uniq.count == 1 && next_line.first.zero?
  end
  totals << last_to_adds.sum + nums.last
end

p totals.sum
