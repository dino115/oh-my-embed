require 'spec_helper'

describe OhMyEmbed::Providers::Slideshare do
  let(:provider) { OhMyEmbed::Providers::Slideshare }
  let(:content_url) { 'http://de.slideshare.net/haraldf/business-quotes-for-2011' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('slideshare') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'SlideShare'
        expect(response.provider_url).to eq 'http://www.slideshare.net'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Business Quotes for 2011'

        expect(response.author).to eq({
          name: 'Harald Felgner (PhD)',
          url: 'http://www.slideshare.net/haraldf',
        })

        expect(response.thumbnail).to eq({
          url: '//cdn.slidesharecdn.com/ss_thumbnails/110103quotes2010-12-110103073149-phpapp01-thumbnail.jpg?cb=1294104671',
          width: 170,
          height: 128,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 425
        expect(response.embed[:height]).to eq 355
      end
    end
  end
end
