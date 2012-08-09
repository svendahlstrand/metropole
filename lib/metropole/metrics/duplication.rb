# encoding: utf-8

require 'flay'

module Metropole
  module Metrics
    class Duplication
      attr_reader :total, :report

      def initialize(ruby_file)
        report = StringIO.new '', 'r+:utf-8'
        old_stdout, $stdout = $stdout, report

        silence_warnings do
          flay = Flay.new mass: 4, summary: true
          flay.process ruby_file.path
          @total = flay.total

          flay.report(report)
          @report = report.string
        end
      ensure
        $stdout = old_stdout
      end
    end
  end
end