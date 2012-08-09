# encoding: utf-8

require 'flay'

module Metropole
  module Metrics
    class Duplication
      def initialize(ruby_file)
        @ruby_file = ruby_file
      end

      def total
        silence_warnings do
          flay = Flay.new mass: 16, summary: true
          flay.process @ruby_file.path
          flay.total
        end
      end
    end
  end
end