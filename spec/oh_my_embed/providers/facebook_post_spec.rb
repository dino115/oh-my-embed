require 'spec_helper'

describe OhMyEmbed::Providers::FacebookPost do
  let(:provider) { OhMyEmbed::Providers::FacebookPost }
  let(:content_url) { 'https://www.facebook.com/FacebookDeutschland/posts/10153796066380932' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('facebook_posts') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'Facebook'
        expect(response.provider_url).to eq 'https://www.facebook.com'

        expect(response.url).to eq content_url

        expect(response.title).to be nil

        expect(response.author).to eq({
          name: 'Facebook',
          url: 'https://www.facebook.com/FacebookDeutschland/',
        })

        expect(response.thumbnail).to be nil

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 552
        expect(response.embed[:height]).to be nil
      end
    end
  end
end
