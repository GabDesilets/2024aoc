#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

times, distances = File.read("input.txt").split("\n")
time = times.scan(/\d+/).join.to_i
distance = distances.scan(/\d+/).join.to_i
timehold_edges = []
# skip the edges

minimal_th = 0
maximal_th = 0
for th in 1..time - 1
  dist_travel = (time - th) * th
  minimal_th = th
  break if dist_travel > distance
end
time.downto(time - minimal_th) do |th|
  dist_travel = (time - th) * th
  maximal_th = th
  break if dist_travel > distance
end
timehold_edges << [minimal_th, maximal_th]

p timehold_edges.map { |e| e[1] + 1 - e[0] }.reduce(:*)
