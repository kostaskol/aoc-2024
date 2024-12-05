# frozen_string_literal: true

require_relative 'base'

module Days
  class D5 < Base
    def part1
      rules, pagesets = parsed_input

      pagesets.sum { |pageset| correct?(pageset, rules) ? pageset[pageset.length / 2] : 0 }
    end

    # This is quite inelegant, but it works.
    # The basic idea is to keep swapping elements until the pageset is correct.
    # If the rules are in any way cyclic, this goes into an infinite loop
    def part2
      rules, pagesets = parsed_input

      invalid_pagesets = pagesets.reject { |pageset| correct?(pageset, rules) }

      invalid_pagesets.sum do |pageset|

        until correct?(pageset, rules)
          rules.each do |rule|
            indexed_hash = indexed_hash(pageset)

            next unless indexed_hash.key?(rule[0]) && indexed_hash.key?(rule[1])

            first_index = indexed_hash[rule[0]]
            second_index = indexed_hash[rule[1]]

            if first_index > second_index
              pageset[first_index], pageset[second_index] = pageset[second_index], pageset[first_index]
            end
          end
        end

        pageset[pageset.length / 2]
      end
    end

    private

    def parsed_input
      return @parsed_input if defined?(@parsed_input)

      @parsed_input = [[], []]
      rules_mode = true

      @lines.each do |line|
        line = line.strip

        if line.empty?
          rules_mode = false
          next
        end

        if rules_mode
          @parsed_input[0] << line.split('|').map(&:to_i)
        else
          @parsed_input[1] << line.split(',').map(&:to_i)
        end
      end

      @parsed_input
    end

    def correct?(pageset, rules)
      # Hash with page number as key and its index as value
      indexed_hash = indexed_hash(pageset)

      rules.all? do |rule|
        # Ignore rules that aren't applicable in this page set
        next true unless indexed_hash.key?(rule[0]) && indexed_hash.key?(rule[1])

        indexed_hash[rule[0]] < indexed_hash[rule[1]]
      end
    end

    def indexed_hash(pageset)
      pageset.each_with_index.to_h
    end
  end
end
