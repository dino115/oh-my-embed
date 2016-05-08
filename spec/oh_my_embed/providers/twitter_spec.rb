require 'spec_helper'

describe OhMyEmbed::Providers::Twitter do
  let(:provider) { OhMyEmbed::Providers::Twitter }
  let(:content_url) { 'https://twitter.com/Interior/status/507185938620219395' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('twitter') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'Twitter'
        expect(response.provider_url).to eq 'https://twitter.com'

        expect(response.url).to eq content_url

        expect(response.title).to be nil

        expect(response.author).to eq({
          name: 'US Dept of Interior',
          url: 'https://twitter.com/Interior',
        })

        expect(response.thumbnail).to be nil

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 550
        expect(response.embed[:height]).to be nil
      end
    end
  end
end
