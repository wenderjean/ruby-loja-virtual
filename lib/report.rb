#coding: utf-8

class Report

  def initialize(library)
    @library = library
  end

  def total
    @library.books.map(&:price).inject(:+)
  end

  def titles
    @library.books.map &:title
  end
end
