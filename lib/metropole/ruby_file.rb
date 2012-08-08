# encoding: utf-8

require 'fileutils'
require 'flay'
require 'flog'

module Metropole
  class RubyFile
    attr_reader :path, :lines, :lines_of_code, :methods

    def initialize(path)
      @path = path
      @lines = @lines_of_code = @methods = 0

      gather_statistics
    end

    def complexity
      @complexity ||= flog_total
    end

    def duplication
      @duplication ||= flay_total
    end

    def html_path
      "metropole/#{File.dirname(@path)}/#{File.basename(@path, '.rb')}.html"
    end

    def content
      File.open(@path, 'r:utf-8') { |file| file.read }
    end

    private

    def flay_total
      silence_warnings do
        flay = Flay.new mass: 16, summary: true
        flay.process @path
        flay.total
      end
    end

    def flog_total
      silence_warnings do
        flog = Flog.new continue: true, parser: RubyParser
        flog.flog @path
        flog.total.to_f.round(1)
      end
    end

    def gather_statistics
      File.open(@path, 'r:utf-8').each_line do |line|
        @lines += 1
        @lines_of_code += 1 unless line =~ /^\s*#/ || line =~ /^\s*$/
        @methods += 1 if line =~ /^\s*def\s+[_a-z]/
      end
    end
  end
end
