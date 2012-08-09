# encoding: utf-8

require 'fileutils'
require 'coderay'

module Metropole
  class Reporter
    def initialize
      @all_files = RubyFile.all_in_current_dir
      @all_files.sort! { |x, y| x.complexity.total <=> y.complexity.total}.reverse!
    end

    def run
      create_overview
      create_details_views
      open_browser
    end

    private

    def create_overview
      FileUtils.mkdir_p 'metropole'

      File.open('metropole/index.html', 'w:utf-8') do |f|
        f.write View.new('index').render(all_files: @all_files)
      end
    end

    def create_details_views
      @all_files.each do |ruby_file|
        FileUtils.mkdir_p ruby_file.html_dirname

        File.open(ruby_file.html_path, 'w:utf-8') do |f|
          f.write View.new('ruby_file').render(file: ruby_file, code: CodeRay.scan(ruby_file.content, :ruby).div(line_numbers: :table))
        end
      end
    end

    def open_browser
      exec 'open metropole/index.html'
    end
  end
end