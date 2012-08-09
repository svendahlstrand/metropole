# encoding: utf-8

require 'flog'

module Metropole
  module Metrics
    class Complexity
      def initialize(ruby_file)
        @ruby_file = ruby_file
      end

      def total
        silence_warnings do
          flog = Flog.new continue: true, parser: RubyParser
          flog.flog @ruby_file.path
          flog.total.to_f.round(1)
        end
      end
    end
  end
end