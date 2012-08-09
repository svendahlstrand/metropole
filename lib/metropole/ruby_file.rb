# encoding: utf-8

require 'fileutils'
require 'forwardable'
require 'flay'
require 'metropole/metrics/code'
require 'metropole/metrics/complexity'

module Metropole
  class RubyFile
    extend Forwardable

    attr_reader :path, :complexity
    def_delegators :@code_metrics, :lines, :lines_of_code, :methods

    def initialize(path)
      @path = path
      @code_metrics = Metropole::Metrics::Code.new(File.new(@path))
      @complexity = Metropole::Metrics::Complexity.new(@path)
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
  end
end
