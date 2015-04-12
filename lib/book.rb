#coding: utf-8

class Book < Media

  field :title
  field :author
  field :isbn
  field :pages
  field :category
  currency :price

  def hash
    @isbn.hash
  end

  def eql?(another)
    @isbn == another.isbn
  end

  def to_s
    "Title: #{title}, Author: #{@author}, ISBN:#{@isbn}, Pages:#{@pages}, Price: #{price}, Category: #{category}"
  end
end
