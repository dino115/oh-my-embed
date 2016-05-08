require 'spec_helper'

describe OhMyEmbed::Providers::Spotify do
  let(:provider) { OhMyEmbed::Providers::Spotify }
  let(:content_url) { 'http://open.spotify.com/track/298gs9ATwr2rD9tGYJKlQR' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('spotify') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'Spotify'
        expect(response.provider_url).to eq 'https://www.spotify.com'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'John De Sohn - Dance Our Tears Away - Radio Edit'

        expect(response.author).to be nil

        expect(response.thumbnail).to eq({
          url: 'https://d3rt1990lpmkn.cloudfront.net/cover/35ff8ecde854e7c713dc4ffad2f31441e7bc1207',
          width: 300,
          height: 300,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 300
        expect(response.embed[:height]).to eq 380
      end
    end
  end
end
