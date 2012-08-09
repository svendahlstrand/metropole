# encoding: utf-8

require 'fileutils'
require 'flay'
require 'flog'
require 'metropole/metrics/code'
require 'forwardable'

module Metropole
  class RubyFile
    extend Forwardable

    attr_reader :path
    def_delegators :@code_metrics, :lines, :lines_of_code, :methods

    def initialize(path)
      @path = path
      @code_metrics = Metropole::Metrics::Code.new(File.new(@path))
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
  end
end
