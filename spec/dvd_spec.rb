require 'spec_helper'

describe Dvd do

  subject {
    Dvd.new title: "Katy Perry", price: 20.0, category: :test
  }

  describe '.price_format' do
    it 'should be $20.0' do
      expect(subject.price_format).to eq("$20.0")
    end
  end

  describe '#save' do
    it 'should save current dvd' do
      subject.save
      expect(File.exist? "db/dvd/#{subject.id}.yml").to eq(true)
    end
  end

  describe '#find(id)' do
    it 'should raise an exception if file does not exists' do
      expect { Dvd.find(subject.id) }.to raise_error
    end

    it 'should return a saved dvd' do
      expect(Dir.glob('db/dvd/*.yml').size).to be > 0
    end
  end

  describe '#find_by_title' do
    it 'should return the dvd saved using :title as filter' do
      expect(Dvd.find_by_title('Katy Perry').first.title).to eq(subject.title)
    end

    it 'should return an empty collection to inexistent dvds' do
      expect(Dvd.find_by_title('Inexistent Dvd').size).to eq(0)
    end

    it 'should raise an exception if find method not starts with find_by_' do
      expect { Dvd.find_for_title(subject.id) }.to raise_error
    end
  end
end

