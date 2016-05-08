require 'spec_helper'

describe OhMyEmbed::Providers::Flickr do
  let(:provider) { OhMyEmbed::Providers::Flickr }
  let(:content_url) { 'https://www.flickr.com/photos/66038491@N06/26861401435/in/explore-2016-05-07/' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a photo response with required attributes' do
      VCR.use_cassette('flickr') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :photo

        expect(response.provider_name).to eq 'Flickr'
        expect(response.provider_url).to eq 'https://www.flickr.com/'

        expect(response.url).to eq 'https://farm8.staticflickr.com/7231/26861401435_c1dbfe8703_b.jpg'

        expect(response.title).to eq 'T-21'

        expect(response.author).to eq({
          name: 'BeyondBrickz',
          url: 'https://www.flickr.com/photos/66038491@N06/',
        })

        expect(response.thumbnail).to eq({
          url: 'https://farm8.staticflickr.com/7231/26861401435_c1dbfe8703_q.jpg',
          width: 150,
          height: 150,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq '1024'
        expect(response.embed[:height]).to eq '629'
      end
    end
  end
end
