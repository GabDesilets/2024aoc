#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

# For each seed range :
#   For each map :
#     We take each range and split them on intersections with given map
#     Then we store the result of the map.
#     And again until there is no range remaining.

seeds, *maps = File.read("example.txt").split("\n\n")
seeds = seeds.split[1..-1].map(&:to_i)
maps = maps.map { |m| m.split("\n")[1..-1].map { |line| line.split().map(&:to_i) } }

locations = []
(0...seeds.length).step(2) do |i| # for each seed range 79 14,  55 13
  ranges = [[seeds[i], seeds[i + 1] + seeds[i]]] # create range from start and length [[79, 93], [55, 68]]
  results = [] # store results of map that are not intersecting with range
  maps.each do |map| # for each map (seed to soil soil to fertilizer etc)
    while !ranges.empty?
      start_range, end_range = ranges.pop
      flag = true
      map.each do |target, start_map, r| # goes through each map and split the range on intersections
        end_map = start_map + r # 50 98 2 = 100
        offset = target - start_map # 50 98 2 = -48
        next if end_map <= start_range || end_range <= start_map # check overlap 100 <= 79 || 93 <= 50

        if start_range < start_map # 79 < 50 are we starting in the middle of the map
          ranges.push([start_range, start_map])
          start_range = start_map
        end
        if end_map < end_range # 100 < 93 are we ending in the middle of the map
          ranges.push([end_map, end_range])
          end_range = end_map
        end
        results.push([start_range + offset, end_range + offset]) # push the result  79 + -48, 93 + -48 = [31 45] intersection of map and range
        flag = false
      end
      if flag # if there is no intersection push the range
        flag = true
        results.push([start_range, end_range])
      end
    end
    ranges = results
    p ranges
    results = []
  end
  locations += ranges
end

puts locations.min_by { |loc| loc[0] }[0]
