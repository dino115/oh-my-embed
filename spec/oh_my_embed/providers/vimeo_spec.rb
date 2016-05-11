require 'spec_helper'

describe OhMyEmbed::Providers::Vimeo do
  let(:provider) { OhMyEmbed::Providers::Vimeo }
  let(:content_url) { 'https://vimeo.com/76979871' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a video response with required attributes' do
      VCR.use_cassette('vimeo') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :video

        expect(response.provider_name).to eq 'Vimeo'
        expect(response.provider_url).to eq 'https://vimeo.com/'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'The New Vimeo Player (You Know, For Videos)'

        expect(response.author).to eq({
          name: 'Vimeo Staff',
          url: 'https://vimeo.com/staff',
        })

        expect(response.thumbnail).to eq({
          url: 'https://i.vimeocdn.com/video/452001751_1280.jpg',
          width: 1280,
          height: 720,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 1280
        expect(response.embed[:height]).to eq 720
      end
    end
  end
end
