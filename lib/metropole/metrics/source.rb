# encoding: utf-8

module Metropole
  module Metrics
    class Source
      attr_reader :lines, :lines_of_code, :methods

      def initialize(ruby_file)
        @ruby_file = ruby_file
        @lines = @lines_of_code = @methods = 0

        gather_statistics
      end

      private

      def gather_statistics
        @ruby_file.content.each_line do |line|
          @lines += 1
          @lines_of_code += 1 unless line =~ /^\s*#/ || line =~ /^\s*$/
          @methods += 1 if line =~ /^\s*def\s+[_a-z]/
        end
      end
    end
  end
end
