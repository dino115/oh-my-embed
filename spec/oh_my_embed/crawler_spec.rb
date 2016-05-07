require 'spec_helper'

module OhMyEmbed::Providers
  class Dummy < OhMyEmbed::Provider
    self.schemes = [
      '//*.example.com/*'
    ]
  end
end

describe OhMyEmbed::Crawler do
  let(:crawler) { OhMyEmbed::Crawler.new }
  let(:url) { 'http://www.example.com/my-content' }

  describe '#initialize' do
    it 'holds the providers in a set' do
      expect(crawler.providers).to be_a Set
    end

    it 'register the default providers with option all: true' do
      expect_any_instance_of(OhMyEmbed::Crawler).to receive(:register_all_build_in_providers)

      OhMyEmbed::Crawler.new all: true
    end

    it 'calls register with all given args' do
      expect_any_instance_of(OhMyEmbed::Crawler).to receive(:register).with(:a)
      expect_any_instance_of(OhMyEmbed::Crawler).to receive(:register).with(:b)

      OhMyEmbed::Crawler.new :a, :b
    end
  end

  describe '#register' do
    it 'finds the provider by symbol and add it to the providers list' do
      expect{ crawler.register(:dummy) }.to change{ crawler.providers.count }.from(0).to(1)
      expect(crawler.providers.first).to be OhMyEmbed::Providers::Dummy
    end

    it 'it add the provider class to the providers list' do
      expect{ crawler.register(OhMyEmbed::Providers::Dummy) }.to change{ crawler.providers.count }.from(0).to(1)
      expect(crawler.providers.first).to be OhMyEmbed::Providers::Dummy
    end

    it 'raises an error if no provider class found' do
      expect{ crawler.register :yolo }.to raise_error OhMyEmbed::UnknownProvider
    end
  end

  describe '#register_all_build_in_providers' do
    it 'adds all the build-in providers' do
      expect{ crawler.register_all_build_in_providers }.to change{ crawler.providers.count }
      expect(crawler.providers.include?(OhMyEmbed::Providers::Dummy)).to be true
    end
  end

  describe '#build_in_providers' do
    it 'returns a symbols array with all build in providers' do
      build_in_providers = crawler.build_in_providers
      expect(build_in_providers).to be_a Array
      expect(build_in_providers.all?{ |p| p.is_a? Symbol }).to be true
      expect(build_in_providers.include?(:Dummy)).to be true
    end
  end

  context 'crawler with a dummy provider' do
    before do
      crawler.register :dummy
    end

    describe '#fetch' do
      it 'calls fetch on the found provider and return an OhMyEmbed::Response' do
        expect(OhMyEmbed::Providers::Dummy).to receive(:fetch).with(url).and_return(OhMyEmbed::Response.new)
        response = crawler.fetch(url)

        expect(response).to be_a OhMyEmbed::Response
      end
    end

    describe '#provider_for' do
      it 'raises a OhMyEmbed::UnknownProvider error if nothing matched' do
        expect{ crawler.provider_for('https://google.de/content') }.to raise_error OhMyEmbed::ProviderNotFound
      end

      it 'finds and return the matching provider' do
        provider = crawler.provider_for(url)
        expect(provider).to be OhMyEmbed::Providers::Dummy
      end
    end

    describe '#embeddable?' do
      it 'returns true for an url that matches a provider schema' do
        expect(crawler.embeddable?(url)).to be true
      end

      it 'returns false if no provider matches' do
        expect(crawler.embeddable?('https://google.de/content')).to be false
      end
    end
  end
end
