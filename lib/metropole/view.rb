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
        template = ERB.new File.read(template_path(@name))
        template.result(OpenStruct.new(options).instance_eval { binding })
      end
    end

    private

    def layout
      layout = ERB.new File.read(template_path('layout'))
      layout.result(binding)
    end

    def template_path(name)
      File.expand_path("../templates/#{name}.html.erb", __FILE__)
    end
  end
end
