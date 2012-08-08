# encoding: utf-8

require 'coderay'

module Metropole
  module Reporter
    def self.run
      all_files = []

      Dir.glob('**/*.rb').each do |path|
        file = Metropole::RubyFile.new(path)

        FileUtils.mkdir_p File.dirname(file.html_path)
        File.open(file.html_path, 'w:utf-8') do |f|
          f.write View.new('ruby_file').render(file: file, code: CodeRay.scan(file.content, :ruby).div(line_numbers: :table))
        end

        all_files << file
      end

      all_files.sort! { |x, y| x.complexity <=> y.complexity }.reverse!

      File.open('metropole/index.html', 'w:utf-8') do |f|
        f.write View.new('index').render(all_files: all_files)
      end

      exec 'open metropole/index.html'
    end
  end
end

