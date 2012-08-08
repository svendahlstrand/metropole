# encoding: utf-8

require 'erb'
require 'ostruct'

module Metropole
  class View
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def render(options)
      layout do
        template = ERB.new File.open(template_path(@name), 'r:utf-8') { |file| file.read }
        template.result(OpenStruct.new(options).instance_eval { binding })
      end
    end

    private

    def layout
      layout = ERB.new File.open(template_path('layout'), 'r:utf-8') { |file| file.read }
      layout.result(binding)
    end

    def template_path(name)
      File.expand_path("../templates/#{name}.html.erb", __FILE__)
    end
  end
end
