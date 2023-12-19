#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

times, distances = File.read("input.txt").split("\n")
time = times.scan(/\d+/).join.to_i
distance = distances.scan(/\d+/).join.to_i

# Find the vertex of the parabola, which is the maximum th
vertex = time / 2

# Find the minimal and maximal th that give a distance greater than d
minimal_th = (1..vertex).find { |th| (time - th) * th > distance }
maximal_th = time.downto(vertex).find { |th| (time - th) * th > distance }

timehold_edges = [[minimal_th, maximal_th]]

p timehold_edges.map { |e| e[1] + 1 - e[0] }.reduce(:*)
