# frozen_string_literal: true

require_relative 'base'

module Days
  class D4 < Base
    P1_WORD = 'XMAS'
    P2_WORD = 'MAS'

    # For each cell, check all 8 possible directions. `follow` fails early,
    # so it does not necessarily check the entire word length if a letter
    # mismatch exists.
    def part1
      sum = 0

      matrix.each_with_index do |row, i|
        row.length.times do |j|
          %i[f b dfd dfu dbd dbu vd vu].each do |direction|
            sum += follow(i, j, direction, P1_WORD)
          end
        end
      end

      sum
    end

    # For each cell with the letter 'A' in it, check the following:
    # * Start from the top left and move diagonally down forward
    # * Start from the top right and move diagonally down backward
    # * Start from the bottom left and move diagonally up forward
    # * Start from the bottom right and move diagonally up backward
    # If at least 2 of the 4 directions contain the word 'MAS', increment the sum.
    # There's an optimization to be made here, as there's no point in checking
    # opposite directions once either one has matched. This would make sense
    # to pursue if the word was longer.
    def part2
      sum = 0

      matrix.each_with_index do |row, i|
        row.length.times do |j|
          # Start from the center of the X
          next unless matrix.dig(i, j) == P2_WORD[1]

          # Top left, top right, bottom left, bottom right
          count = diagonal_neighbours(i, j).sum do |direction, (i_next, j_next)|
            follow(i_next, j_next, direction, P2_WORD)
          end

          sum += 1 if count >= 2
        end
      end

      sum
    end

    private

    def follow(i, j, direction, word)
      i_next, j_next = resolved_direction(direction)


      word.length.times do |k|
        next_el_i = i_next.call(i, k)
        next_el_j = j_next.call(j, k)

        break unless valid?(next_el_i, next_el_j)
        break unless matrix.dig(next_el_i, next_el_j) == word[k]

        return 1 if k == word.length - 1
      end

      0
    end

    def resolved_direction(direction)
      return @mem[direction] if defined?(@mem) && @mem.key?(direction)

      @mem ||= {}

      @mem[direction] =
        case direction
        when :f
          [->(i, _k) { i }, ->(j, k) { j + k }]
        when :b
          [->(i, _k) { i }, ->(j, k) { j - k }]
        when :vd
          [->(i, k) { i + k }, ->(j, _k) { j }]
        when :vu
          [->(i, k) { i - k }, ->(j, _k) { j }]
        when :dfd
          [->(i, k) { i + k }, ->(j, k) { j + k }]
        when :dfu
          [->(i, k) { i - k }, ->(j, k) { j + k }]
        when :dbd
          [->(i, k) { i + k }, ->(j, k) { j - k }]
        when :dbu
          [->(i, k) { i - k }, ->(j, k) { j - k }]
        else
          raise "Unknown direction #{direction}"
        end
    end

    def diagonal_neighbours(i, j)
      {
        dfd: [i - 1, j - 1],
        dbd: [i - 1, j + 1],
        dfu: [i + 1, j - 1],
        dbu: [i + 1, j + 1]
      }
    end

    def matrix
      return @matrix if defined?(@matrix)

      @matrix = @lines.each_with_object([]).with_index do |(line, acc), index|
        acc[index] = line.split('')
      end
    end

    def valid?(i, j)
      i >= 0 && j >= 0 && @matrix.length > i && @matrix[i].length > j
    end
  end
end
