# encoding: utf-8

require 'ostruct'
require 'flog'

module Metropole
  module Metrics
    class Complexity
      attr_reader :total, :report

      def initialize(ruby_file)
        silence_warnings do
          flog = Flog.new continue: true, methods: true, parser: RubyParser
          flog.flog ruby_file.path
          @total = flog.total.to_f.round(1)

          # Create report
          @report = []

          flog.each_by_score do |class_and_method_name, score|
            break if score < 20

            method_name = class_and_method_name.split('#')[1]
            line_number = flog.method_locations[class_and_method_name].split(':')[1]

            @report << OpenStruct.new(method_name: method_name, line_number: line_number )
          end
        end
      end
    end
  end
end