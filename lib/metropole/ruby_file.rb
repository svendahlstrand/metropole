# encoding: utf-8

require 'forwardable'

module Metropole
  class RubyFile
    extend Forwardable

    attr_reader :path, :complexity, :duplication
    def_delegators :@source_metrics, :lines, :lines_of_code, :methods

    def initialize(path)
      @path = path
      @source_metrics = Metrics::Source.new(self)
      @complexity = Metrics::Complexity.new(self)
      @duplication = Metrics::Duplication.new(self)
    end

    def html_path
      "metropole/#{File.dirname(@path)}/#{File.basename(@path, '.rb')}.html"
    end

    def html_dirname
      File.dirname(html_path)
    end

    def content
      @content ||= File.open(@path, 'r:utf-8') { |file| file.read }
    end

    def self.all_in_current_dir
      Dir.glob('**/*.rb').map do |path|
        self.new(path)
      end
    end
  end
end
