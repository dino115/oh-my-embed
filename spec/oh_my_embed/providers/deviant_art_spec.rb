require 'spec_helper'

describe OhMyEmbed::Providers::DeviantArt do
  let(:provider) { OhMyEmbed::Providers::DeviantArt }
  let(:content_url) { 'http://fav.me/d2enxz7' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a video response with required attributes' do
      VCR.use_cassette('deviantart') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :photo

        expect(response.provider_name).to eq 'DeviantArt'
        expect(response.provider_url).to eq 'http://www.deviantart.com'

        expect(response.url).to eq 'http://orig03.deviantart.net/3c1c/f/2009/336/4/7/cope_by_pachunka.jpg'

        expect(response.title).to eq 'Cope'

        expect(response.author).to eq({
          name: 'Pachunka',
          url: 'http://Pachunka.deviantart.com',
        })

        expect(response.thumbnail).to eq({
          url: 'http://t10.deviantart.net/nHw1FLNfxnT4ga1BPKmlV3V7h2E=/fit-in/300x900/filters:no_upscale():origin()/pre11/dde3/th/pre/f/2009/336/4/7/cope_by_pachunka.jpg',
          width: 300,
          height: 450,
        })

        expect(response.embed[:html]).to be nil
        expect(response.embed[:width]).to eq '448'
        expect(response.embed[:height]).to eq '672'
      end
    end
  end
end
