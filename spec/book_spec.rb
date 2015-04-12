require 'spec_helper'

describe Book do

  subject {
    Book.new title: "First Book", isbn: "A1", pages: 120, price: 20.0, category: :test
  }

  describe '.discount()' do
    it 'should be 0.1' do
      expect(subject.discount()).to eq(0.1)
    end
  end

  describe '.price_with_discount()' do
    it 'should be ' do
      expect(subject.price_with_discount()).to eq(18.0)
    end
  end

  describe '#Mask::currency()' do
    it 'should be $20.0' do
      expect(subject.price_format).to eq("$20.0")
    end
  end

  describe '#save' do
    it 'should save current book' do
      subject.save
      expect(File.exist? "db/book/#{subject.id}.yml").to eq(true)
    end
  end

  describe '#find(id)' do
    it 'should raise an exception if file does not exists' do
      expect { Book.find(subject.id) }.to raise_error
    end

    it 'should return a saved dvd' do
      expect(Dir.glob('db/book/*.yml').size).to be > 0
    end
  end

  describe '#find_by_title' do
    it 'should return the book saved using :title as filter' do
      expect(Book.find_by_title('First Book').first.title).to eq(subject.title)
    end

    it 'should return an empty collection to inexistent books' do
      expect(Book.find_by_title('Inexistent Book').size).to eq(0)
    end

    it 'should raise an exception if find method not starts with find_by_' do
      expect { Book.find_for_title(subject.id) }.to raise_error
    end
  end
end
