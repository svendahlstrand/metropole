# encoding: utf-8

require 'flay'

module Metropole
  module Metrics
    class Duplication
      def initialize(path)
        @path = path
      end

      def total
        silence_warnings do
          flay = Flay.new mass: 16, summary: true
          flay.process @path
          flay.total
        end
      end
    end
  end
end