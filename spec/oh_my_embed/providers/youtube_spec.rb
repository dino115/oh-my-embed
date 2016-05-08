require 'spec_helper'

describe OhMyEmbed::Providers::Youtube do
  let(:provider) { OhMyEmbed::Providers::Youtube }
  let(:content_url) { 'http://www.youtube.com/watch?v=EErY75MXYXI' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a video response with required attributes' do
      VCR.use_cassette('youtube') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :video

        expect(response.provider_name).to eq 'YouTube'
        expect(response.provider_url).to eq 'https://www.youtube.com/'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Nyan Cat - 24 Hour Edition'

        expect(response.author).to eq({
          name: 'NyaAnimeParty',
          url: 'https://www.youtube.com/user/NyaAnimeParty',
        })

        expect(response.thumbnail).to eq({
          url: 'https://i.ytimg.com/vi/EErY75MXYXI/hqdefault.jpg',
          width: 480,
          height: 360,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 459
        expect(response.embed[:height]).to eq 344
      end
    end
  end
end
