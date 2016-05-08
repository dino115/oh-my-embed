require 'spec_helper'

class DummyProvider < OhMyEmbed::Provider
  self.provider_name = 'My Dummy Provider'
  self.endpoint = 'https://www.example.com/api/oembed'
  self.schemes = [
    '//*.example.com/*',
    'http://www.example.com/*/*',
  ]
  self.custom_mapping = {
    'type' => 'custom_type'
  }
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

  describe '#fetch' do
    it 'requests the providers endpoint with correct params' do
      stub = stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_return do |request|
        params = CGI::parse(request.uri.query)
        expect(params['format'].first).to eq 'json'
        expect(params['url'].first).to eq 'http://example.com/my/content'

        { body: '{}' }
      end

      DummyProvider.fetch('http://example.com/my/content')

      expect(stub).to have_been_requested
    end

    it 'fails with an OhMyEmbed::NotFound on staus 404 (not found)' do
      stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_return(status: [404, 'Not Found'])
      expect{ DummyProvider.fetch('http://example.com/my/content') }.to raise_error OhMyEmbed::NotFound
    end

    it 'fails with an OhMyEmbed::PermissionDenied on staus 401 (unauthorized)' do
      stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_return(status: [401, 'Unauthorized'])
      expect{ DummyProvider.fetch('http://example.com/my/content') }.to raise_error OhMyEmbed::PermissionDenied
    end

    it 'fails with an OhMyEmbed::FormatNotSupportet on status 501 (not implemented)' do
      stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_return(status: [501, 'Not Implemented'])
      expect{ DummyProvider.fetch('http://example.com/my/content') }.to raise_error OhMyEmbed::FormatNotSupported
    end

    it 'fails with an OhMyEmbed::Error on request timeout' do
      stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_timeout
      expect{ DummyProvider.fetch('http://example.com/my/content') }.to raise_error OhMyEmbed::Error
    end

    it 'fails with an OhMyEmbed::ParseError if endpoint returns malformed json' do
      stub_request(:get, /^https:\/\/www\.example\.com\/api\/oembed/).to_return(body: '<yolo this="is xml">')

      expect{ DummyProvider.fetch('http://example.com/my/content') }.to raise_error OhMyEmbed::ParseError
    end
  end

  describe '#mapping' do
    it 'returns a hash where defaults merged with the custom mapping' do
      expect(DummyProvider.mapping['type']).to eq 'custom_type'
      expect(DummyProvider.mapping['provider_name']).to eq 'provider_name'
    end
  end

  describe '#provider_name' do
    it 'returns the provider name if given' do
      expect(DummyProvider.provider_name).to eq 'My Dummy Provider'
    end

    it 'return the provider_name extracted from class name if no provider_name given' do
      expect(OhMyEmbed::Provider.provider_name).to eq 'Provider'
    end
  end
end
