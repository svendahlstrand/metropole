# encoding: utf-8

require 'fileutils'
require 'forwardable'
require 'metropole/metrics/source'
require 'metropole/metrics/complexity'
require 'metropole/metrics/duplication'

module Metropole
  class RubyFile
    extend Forwardable

    attr_reader :path, :complexity, :duplication
    def_delegators :@source_metrics, :lines, :lines_of_code, :methods

    def initialize(path)
      @path = path
      @source_metrics = Metropole::Metrics::Source.new(File.new(@path))
      @complexity = Metropole::Metrics::Complexity.new(@path)
      @duplication = Metropole::Metrics::Duplication.new(@path)
    end

    def html_path
      "metropole/#{File.dirname(@path)}/#{File.basename(@path, '.rb')}.html"
    end

    def content
      File.open(@path, 'r:utf-8') { |file| file.read }
    end
  end
end
