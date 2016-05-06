require 'spec_helper'

module OhMyEmbed::Providers
  class Dummy < OhMyEmbed::Provider
  end
end

describe OhMyEmbed::Crawler do
  describe '#initialize' do
    it 'calls register with all given args' do
      expect_any_instance_of(OhMyEmbed::Crawler).to receive(:register).with(:a)
      expect_any_instance_of(OhMyEmbed::Crawler).to receive(:register).with(:b)

      OhMyEmbed::Crawler.new :a, :b
    end
  end

  describe '#register' do
    let!(:crawler) do
      OhMyEmbed::Crawler.new
    end

    it 'finds the provider by symbol and add it to the providers list' do
      expect{ crawler.register(:dummy) }.to change{ crawler.providers.count }.from(0).to(1)
      expect(crawler.providers.first).to be OhMyEmbed::Providers::Dummy
    end

    it 'it add the prover class to the providers list' do
      expect{ crawler.register(OhMyEmbed::Providers::Dummy) }.to change{ crawler.providers.count }.from(0).to(1)
      expect(crawler.providers.first).to be OhMyEmbed::Providers::Dummy
    end
  end
end
