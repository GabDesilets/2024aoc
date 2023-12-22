#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all
path = "input.txt"
instructions, network = File.read(path).split("\n\n")
instructions = instructions.chars
r = /(\w+) = \((\w+), (\w+)\)/
nodes = {}
starting_nodes = {}
network
  .split("\n")
  .each do |line|
    node = line.scan(r)[0] # [name, left, right]

    starting_nodes[node[0]] = [node[1], node[2]] if node[0].chars[2] == "A"
    nodes[node[0]] = [node[1], node[2]]
  end
steps = []
instruction_count = instructions.count

starting_nodes.each do |node, lr|
  step = 0
  while node.chars[2] != "Z"
    case instructions[step % instruction_count]
    when "R"
      node = nodes[node][1]
    when "L"
      node = nodes[node][0]
    end
    puts "#{node} #{instructions[step % instruction_count]}"
    step += 1
  end
  steps << step
end
p steps
puts steps.reduce(1, :lcm)
