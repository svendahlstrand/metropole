# encoding: utf-8

require 'ostruct'
require 'flog'

module Metropole
  module Metrics
    class Complexity
      attr_reader :total_score, :hotspots

      SCORE_LIMIT = 20

      def initialize(ruby_file)
        flog = run_flog(ruby_file)

        @total_score = flog.total.to_f.round(1)
        @hotspots = get_hotspots flog
      end

      private

      def run_flog(ruby_file)
        flog = Flog.new continue: true, methods: true, parser: RubyParser
        flog.flog ruby_file.path
        flog
      end

      def get_hotspots(flog)
        hotspots = []

        flog.each_by_score do |class_and_method_name, score|
          break if score < SCORE_LIMIT

          method_name = class_and_method_name.split('#')[1]
          line_number = flog.method_locations[class_and_method_name].split(':')[1]

          hotspots << OpenStruct.new(method_name: method_name, line_number: line_number )
        end

        hotspots
      end
    end
  end
end