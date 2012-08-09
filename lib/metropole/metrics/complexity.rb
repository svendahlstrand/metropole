# encoding: utf-8

require 'flog'

module Metropole
  module Metrics
    class Complexity
      attr_reader :total, :report

      def initialize(ruby_file)
        silence_warnings do
          flog = Flog.new continue: true, parser: RubyParser
          flog.flog ruby_file.path
          @total = flog.total.to_f.round(1)

          report = StringIO.new '', 'r+:utf-8'
          flog.report(report)
          @report = report.string
        end
      end
    end
  end
end