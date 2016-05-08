require 'spec_helper'

describe OhMyEmbed::Providers::Soundcloud do
  let(:provider) { OhMyEmbed::Providers::Soundcloud }
  let(:content_url) { 'https://soundcloud.com/forss/flickermood' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('soundcloud') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'SoundCloud'
        expect(response.provider_url).to eq 'http://soundcloud.com'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Flickermood by Forss'

        expect(response.author).to eq({
          name: 'Forss',
          url: 'http://soundcloud.com/forss',
        })

        expect(response.thumbnail).to eq({
          url: 'http://i1.sndcdn.com/artworks-000067273316-smsiqx-t500x500.jpg',
          width: nil,
          height: nil,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq '100%'
        expect(response.embed[:height]).to eq 400
      end
    end
  end
end
