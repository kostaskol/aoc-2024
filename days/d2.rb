# frozen_string_literal: true

require_relative 'base'

module Days
  class D2 < Base
    def part1
      @lines.count do |line|
        reports = line.split.map(&:to_i)

        inc = (reports[0] - reports[1]).negative?

        reports.each_cons(2).all? { |a, b| safe?(a, b, inc) }
      end
    end

    def part2
      @lines.count do |line|
        reports = line.split.map(&:to_i)

        inc = reports.each_cons(2).count { |a, b| (a - b).negative? } > 2

        reports.size.times.any? do |i|
          checked_reports = reports.dup
          checked_reports.delete_at(i)

          inc = (checked_reports[0] - checked_reports[1]).negative?

          checked_reports.each_cons(2).all? { |a, b| safe?(a, b, inc) }
        end
      end
    end

    private

    def safe?(a, b, inc)
      return false if (a - b).negative? != inc

      diff = (a - b).abs

      diff.positive? && diff < 4
    end
  end
end
