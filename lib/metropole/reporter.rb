require 'erb'
require 'tilt'

module Metropole
  module Reporter
    def self.run
      all_files = []

      Dir.glob('**/*.rb').each do |path|
        file = Metropole::RubyFile.new(path)

        FileUtils.mkdir_p File.dirname(file.html_path)
        File.open(file.html_path, 'w:utf-8') do |f|
          f.write erb('ruby_file', file: file)
        end

        all_files << file
      end

      all_files.sort! { |x, y| x.complexity <=> y.complexity }.reverse!

      File.open('metropole/index.html', 'w:utf-8') do |f|
        f.write erb('index', all_files: all_files)
      end

      exec 'open metropole/index.html'
    end

    private

    def self.erb(view, options)
      layout = Tilt::ERBTemplate.new(File.expand_path('../templates/layout.html.erb', __FILE__))
      layout.render do
        template = Tilt::ERBTemplate.new(File.expand_path("../templates/#{view}.html.erb", __FILE__))
        template.render(self, options)
      end
    end
  end
end

