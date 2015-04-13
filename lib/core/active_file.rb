#coding: utf-8

require 'yaml'
require 'fileutils'

module ActiveFile
  def save
    File.open("db/#{self.class.name}/#{id}.yml", "w") do |file|
      @new_record = false
      file.puts serialize
    end
  end

  def destroy
    unless @destroyed or @new_record
      @destroyed = true
      FileUtils.rm "db/#{self.class.name}/#{id}.yml"
    end
  end

  module ClassMethods
    def method_missing(name, *args, &block)
      super unless name.to_s =~ /^find_by_(.*)/
      argument = args.first
      field = $1
      super if @fields.include? field

      load_all.select do |object|
        should_select? object, field, argument
      end
    end

    def field(name)
      @fields ||= []
      @fields << name

      get = %Q{
        def #{name}
          @#{name}
        end
      }

      set = %Q{
        def #{name}=(value)
          @#{name} = value
        end
      }

      self.class_eval get
      self.class_eval set
    end

    def find(id)
      class_name = self.ancestors.first
      raise DocumentNotFound, "File db/#{class_name}/#{id}.yml not found.", caller unless File.exist? "db/#{class_name}/#{id}.yml"
      YAML.load File.open("db/#{class_name}/#{id}.yml", "r")
    end

    def next_id
      Dir.glob("db/#{self.ancestors.first}/*.yml").size + 1
    end

    private

    def should_select?(object, field, argument)
      if argument.kind_of? Regexp
        object.send(field) =~ argument
      else
        object.send(field) == argument
      end
    end

    def load_all
      Dir.glob("db/#{self.ancestors.first}/*.yml").map do |file|
        deserialize file
      end
    end

    def deserialize(file)
      YAML.load File.open(file, "r")
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      attr_reader :id, :destroyed, :new_record

      def initialize(parameters = {})
        @id = self.class.next_id
        @destroyed = false
        @new_record = true

        parameters.each do |key, value|
          instance_variable_set "@#{key}", value
        end
      end
    end
  end

  private

  def serialize
    YAML.dump self
  end
end
