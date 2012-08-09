# encoding: utf-8

module Metropole
  module Metrics
    class Code
      attr_reader :lines, :lines_of_code, :methods

      def initialize(file)
        @file = file
        @lines = @lines_of_code = @methods = 0

        gather_statistics
      end

      private

      def gather_statistics
        File.open(@file, 'r:utf-8').each_line do |line|
          @lines += 1
          @lines_of_code += 1 unless line =~ /^\s*#/ || line =~ /^\s*$/
          @methods += 1 if line =~ /^\s*def\s+[_a-z]/
        end
      end
    end
  end
end
