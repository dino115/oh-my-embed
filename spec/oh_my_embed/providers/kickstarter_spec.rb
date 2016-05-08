require 'spec_helper'

describe OhMyEmbed::Providers::Kickstarter do
  let(:provider) { OhMyEmbed::Providers::Kickstarter }
  let(:content_url) { 'https://www.kickstarter.com/projects/531257408/professional-3-stage-knife-sharpener?ref=category_popular' }

  it 'the content_url matches the schema' do
    expect(provider.regex).to match content_url
  end

  describe 'fetching' do
    it 'returns a rich response with required attributes' do
      VCR.use_cassette('kickstarter') do
        response = provider.fetch(content_url)

        expect(response).to be_a OhMyEmbed::Response

        expect(response.type).to eq :rich

        expect(response.provider_name).to eq 'Kickstarter'
        expect(response.provider_url).to eq 'https://www.kickstarter.com/'

        expect(response.url).to eq content_url

        expect(response.title).to eq 'Professional 3 Stage Knife Sharpener'

        expect(response.author).to eq({
          name: 'Kongqiang',
          url: 'https://www.kickstarter.com/profile/531257408',
        })

        expect(response.thumbnail).to eq({
          url: 'https://ksr-ugc.imgix.net/projects/2452435/photo-original.jpg?w=560&h=315&fit=fill&bg=FFFFFF&v=1461877181&auto=format&q=92&s=aae8e61c91e611fd27cc2db1c25a8916',
          width: 560,
          height: 315,
        })

        expect(response.embed[:html]).to be_a String
        expect(response.embed[:width]).to eq 480
        expect(response.embed[:height]).to eq 270
      end
    end
  end
end
