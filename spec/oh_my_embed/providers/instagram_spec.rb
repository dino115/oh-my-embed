require 'spec_helper'

describe OhMyEmbed::Providers::Instagram do
  let(:provider) { OhMyEmbed::Providers::Instagram }
  let(:content_url) { 'http://instagr.am/p/fA9uwTtkSN' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('instagram') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'Instagram'
        expect(response.provider_url).to eq 'https://www.instagram.com'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Wii Gato (Lipe Sleep)'

        expect(response.author).to eq({
          name: 'diegoquinteiro',
          url: 'https://www.instagram.com/diegoquinteiro',
        })

        expect(response.thumbnail[:url]).to be_a String
        expect(response.thumbnail[:width]).to eq 640
        expect(response.thumbnail[:height]).to eq 640

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 658
        expect(response.embed[:height]).to be nil
      end
    end
  end
end
