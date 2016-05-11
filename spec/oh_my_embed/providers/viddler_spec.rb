require 'spec_helper'

describe OhMyEmbed::Providers::Viddler do
  let(:provider) { OhMyEmbed::Providers::Viddler }
  let(:content_url) { 'http://www.viddler.com/v/bdce8c7' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a video response with required attributes' do
      VCR.use_cassette('viddler') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :video

        expect(response.provider_name).to eq 'Viddler'
        expect(response.provider_url).to eq 'http://www.viddler.com/'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Viddler Platform Overview'

        expect(response.author).to eq({
          name: 'viddler',
          url: 'http://viddler.com',
        })

        expect(response.thumbnail).to eq({
           url: 'http://thumbs.cdn-ec.viddler.com/thumbnail_2_bdce8c7_v8.jpg',
           width: 620,
           height: 349,
         })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 620
        expect(response.embed[:height]).to eq 349
      end
    end
  end
end
