# frozen_string_literal: true

require_relative 'base'

module Days
  # While today's input was given in multiple lines, the puzzle
  # (and solution) expects them to be concatenated into a single line.
  # To avoid doing this in the code, it must be done manually directly
  # in the input file
  class D3 < Base
    def part1
      @lines.sum do |line|
        line.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum do |x, y|
          x.to_i * y.to_i
        end
      end
    end

    def part2
      enabled = true

      @lines.sum do |line|
        line.scan(/(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))/).sum do |match|
          if match[0] == 'do()'
            enabled = true
          elsif match[0] == "don't()"
            enabled = false
          elsif enabled
            next match[1].to_i * match[2].to_i
          end

          0
        end
      end
    end
  end
end
