require 'spec_helper'

class DummyProvider < OhMyEmbed::Provider
  self.schemes = [
    '//*.example.com/*',
    'http://www.example.com/*/*',
  ]
end

describe OhMyEmbed::Provider do
  describe '::regex' do
    it 'returns a union regex to match both url schemes' do
      regex = DummyProvider.regex
      expect(regex).to match 'https://www.example.com/yolo'
      expect(regex).to match 'http://www.example.com/x/y'
    end
  end

  describe '::regexify' do
    it 'does nothing with an Regexp object' do
      regex = Regexp.new('.*')
      expect(DummyProvider.regexify(regex)).to be regex
    end

    it 'creates a regular expression from string' do
      result = DummyProvider.regexify(DummyProvider.schemes.last)
      expect(result).to be_a Regexp
      expect(result).to eq /^http:\/\/www\.example\.com\/(.*?)\/(.*?)$/i
      expect(result).to match 'http://www.example.com/yolo/swag'
    end

    it 'prepends http and https if no protocol given' do
      result = DummyProvider.regexify(DummyProvider.schemes.first)
      expect(result).to be_a Regexp
      expect(result).to eq /^(https:|http:)\/\/(.*?)\.example\.com\/(.*?)$/i
      expect(result).to match 'https://rofl.example.com/yolo'
    end
  end
end
