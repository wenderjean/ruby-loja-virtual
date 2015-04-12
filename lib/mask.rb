#coding: utf-8

module Mask
  def currency(*variables_and_methods)
    variables_and_methods.each do |name|
      define_method("#{name}_format") do
        value = respond_to?(name) ? send(name) : instance_variable_get("@#{name}")
        "$#{value}"
      end
    end
  end
end
