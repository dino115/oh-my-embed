require 'spec_helper'

describe OhMyEmbed::Providers::Dailymotion do
  let(:provider) { OhMyEmbed::Providers::Dailymotion }
  let(:content_url) { 'http://www.dailymotion.com/video/x49ug8z_faszination-pferderennen-heute-eine-schule-fur-den-jockey-nachwuchs_sport' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a video response with required attributes' do
      VCR.use_cassette('dailymotion') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :video

        expect(response.provider_name).to eq 'Dailymotion'
        expect(response.provider_url).to eq 'https://www.dailymotion.com'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Faszination Pferderennen - Heute: Eine Schule für den Jockey-Nachwuchs'

        expect(response.author).to eq({
          name: 'A Group',
          url: 'https://www.dailymotion.com/auer1',
        })

        expect(response.thumbnail).to eq({
          url: 'https://s2-ssl.dmcdn.net/XDvvJ/x240-cMm.jpg',
          width: 427,
          height: 240,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 480
        expect(response.embed[:height]).to eq 269
      end
    end
  end
end
