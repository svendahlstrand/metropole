# encoding: utf-8

require 'ostruct'
require 'flay'

module Metropole
  module Metrics
    class Duplication
      attr_reader :total, :hotspots

      def initialize(ruby_file)
        report = StringIO.new '', 'r+:utf-8'
        old_stdout, $stdout = $stdout, report

        flay = Flay.new mass: 15
        flay.process ruby_file.path
        @total = flay.total

        flay.report

        @hotspots = get_hotspots(report.string)
      ensure
        $stdout = old_stdout
      end

      def get_hotspots(report)
        hotspot = nil
        hotspots = []

        report.each_line do |line|
          case line
          when /^\d+\)/
            hotspot = { heading: $'.strip, line_numbers: [] }
            hotspots << OpenStruct.new(hotspot)
          when /\w:(\d+)/
            hotspot[:line_numbers] << $1.to_i
          end
        end

        hotspots
      end
    end
  end
end