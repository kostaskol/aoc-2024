# frozen_string_literal: true

require_relative 'base'

module Days
  class D1 < Base
    def part1
      left, right = @lines.map { _1.split.map(&:to_i) }.transpose.map(&:sort)

      left.zip(right).sum { |a, b| (a - b).abs }
    end

    def part2
      left, right = @lines.map { _1.split.map(&:to_i) }.transpose.map(&:sort)

      right_counts = right.each_with_object(Hash.new(0)) do |element, acc|
        acc[element] += 1
      end

      left.sum do |element|
        element * right_counts[element]
      end
    end
  end
end
