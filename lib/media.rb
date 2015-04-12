#coding: utf-8

class Media
  extend Mask
  include ActiveFile

  field :title
  field :price
  field :discount
  field :category

  def discount
    0.1
  end

  def price_with_discount
    @price - (@price * discount)
  end
end
