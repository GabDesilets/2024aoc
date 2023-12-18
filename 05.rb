#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

class Part1
  class << self
    def create_conversion_map(maps, key)
      conversion_map = {}
      maps[key].each { |map| conversion_map[map[1]] = { range: map[2], dest: map[0], source: map[1] } }
      conversion_map
    end

    def find_mapping(conversion_map, value)
      conversion_map.each do |key, map|
        next key unless value.between?(map[:source], (map[:source] - 1) + map[:range])
        extra = value - map[:source]

        return map[:dest] + extra
      end
      value
    end

    def execute(lines)
      seeds = lines[0].split(":")[1].scan(/\d+/).map(&:to_i)
      lines.shift

      maps = {}
      almanac = {}
      current_map = nil
      lines.each do |line|
        next if line.empty?
        map = line.scan(/\w+-\w+-\w+/)
        current_map = map[0] if map.any?
        next if map.any?

        maps[current_map] = [] if maps[current_map].nil?
        maps[current_map].push line.scan(/\d+/).map(&:to_i).flatten if line.match(/^\d+ \d+ \d+$/)
      end

      # Create all conversion maps first
      conversion_maps =
        %w[
          seed-to-soil
          soil-to-fertilizer
          fertilizer-to-water
          water-to-light
          light-to-temperature
          temperature-to-humidity
          humidity-to-location
        ].each_with_object({}) { |key, hash| hash[key] = create_conversion_map(maps, key) }

      # Update the almanac in a single loop

      seeds.each do |seed|
        soil = find_mapping(conversion_maps["seed-to-soil"], seed)
        fertilizer = find_mapping(conversion_maps["soil-to-fertilizer"], soil)
        water = find_mapping(conversion_maps["fertilizer-to-water"], fertilizer)
        light = find_mapping(conversion_maps["water-to-light"], water)
        temperature = find_mapping(conversion_maps["light-to-temperature"], light)
        humidity = find_mapping(conversion_maps["temperature-to-humidity"], temperature)
        location = find_mapping(conversion_maps["humidity-to-location"], humidity)

        almanac[seed] = {
          soil: soil,
          fertilizer: fertilizer,
          water: water,
          light: light,
          temperature: temperature,
          humidity: humidity,
          location: location,
        }
      end
      p lowest_location = almanac.values.min_by { |data| data[:location] }[:location]
    end
  end
end

Part1.execute ARGF.read.split("\n")
