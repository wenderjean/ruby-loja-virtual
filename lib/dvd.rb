#coding: utf-8

class Dvd < Media

  field :title
  field :price
  field :category
  currency :price
end
