#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all
path = "input.txt"
instructions, network = File.read(path).split("\n\n")
@instructions = instructions.chars
r = /(\w+) = \((\w+), (\w+)\)/
nodes = {}
network
  .split("\n")
  .each do |line|
    node = line.scan(r)[0] # [name, left, right]

    nodes[node[0]] = [node[1], node[2]]
  end
@steps = 0
@instruction_count = @instructions.count
# redo with map + recursion

puts @steps % @instruction_count
def walk_nodes(nodes, current_node)
  while current_node != "ZZZ"
    node = nodes[current_node]
    p current_node
    next_node = nil
    case @instructions[@steps % @instruction_count]
    when "R"
      next_node = nodes[node[1]]
    when "L"
      next_node = nodes[node[0]]
    end
    @steps += 1

    current_node = next_node
  end
end

walk_nodes(nodes, "AAA")
puts @steps
