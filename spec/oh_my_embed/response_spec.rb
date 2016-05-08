require 'spec_helper'

class ExampleProvider < OhMyEmbed::Provider
  self.endpoint = 'https://www.example.com/api/oembed'
end

describe OhMyEmbed::Response do
  let(:response) do
    OhMyEmbed::Response.new(
      ExampleProvider,
      'http://www.example.com/url/to/my/content',
      {
        'type' => 'rich',
        'version' => '1.0',
        'title' => 'My content',
        'author_name' => 'John Doe',
        'author_url' => 'http://www.example.com/users/john.doe',
        'provider_name' => 'My awesome example provider',
        'provider_url' => 'http://www.example.com',
        'cache_age' => '3600',
        'thumbnail_url' => 'http://www.example.com/images/my-content.png',
        'thumbnail_width' => 200,
        'thumbnail_height' => 200,
        'url' => 'http://www.example.com/my/content',
        'html' => '<iframe src="http://www.example.com/embed/my-content" />',
        'width' => 640,
        'height' => 480,
      }
    )
  end

  describe '#initialize' do
    it 'holds the provider' do
      expect(response.provider).to be ExampleProvider
    end

    it 'holds the url' do
      expect(response.url).to eq 'http://www.example.com/my/content'
    end

    it 'holds the attributes' do
      expect(response.attributes).to be_a Hash
      expect(response.attributes.keys).to match_array %w[ type version title author_name author_url provider_name provider_url cache_age thumbnail_url thumbnail_width thumbnail_height url html width height ]
    end
  end

  describe '#attribute' do
    it 'fetch an attribute by symbol' do
      expect(response.attribute(:title)).to eq 'My content'
    end

    it 'fetch an attribute by string' do
      expect(response.attribute('title')).to eq 'My content'
    end

    it 'returns nil if attribute isn\'t present in attributes' do
      expect(response.attribute('yolo')).to eq nil
    end
  end

  describe '#type' do
    it 'returns the symbolized value of the type attribute' do
      expect(response.type).to eq :rich
    end
  end

  describe '#provider_name' do
    it 'returns the provider_name' do
      expect(response.provider_name).to eq 'My awesome example provider'
    end

    it 'returns the providers provider_name if provider name isn\'t set in the response data' do
      response.attributes['provider_name'] = nil
      expect(response.provider_name).to eq 'ExampleProvider'
    end
  end

  describe '#provider_url' do
    it 'returns the provider_url' do
      expect(response.provider_url).to eq 'http://www.example.com'
    end

    it 'returns the providers endpoint url if there is no provider_url in response data' do
      response.attributes['provider_url'] = nil
      expect(response.provider_url).to eq 'https://www.example.com/api/oembed'
    end
  end

  describe '#url' do
    it 'returns the url' do
      expect(response.url).to eq 'http://www.example.com/my/content'
    end

    it 'returns the requestet content_url if there is no url in response data' do
      response.attributes['url'] = nil
      expect(response.url).to eq 'http://www.example.com/url/to/my/content'
    end
  end

  describe '#title' do
    it 'returns the title' do
      expect(response.title).to eq 'My content'
    end

    it 'returns nil if no title in response found' do
      response.attributes['title'] = nil
      expect(response.title).to be_nil
    end
  end

  describe '#author' do
    it 'returns an author hash' do
      expect(response.author).to be_a Hash
    end
    it 'contains the author_name' do
      expect(response.author[:name]).to eq 'John Doe'
    end
    it 'contains the author_url' do
      expect(response.author[:url]).to eq 'http://www.example.com/users/john.doe'
    end
    it 'returns nil if author_name and author_url are nil' do
      response.attributes['author_name'] = nil
      response.attributes['author_url'] = nil
      expect(response.author).to be nil
    end
  end

  describe '#thumbnail' do
    it 'returns a thumbnail hash' do
      expect(response.thumbnail).to be_a Hash
    end

    it 'contains the thumbnail_url' do
      expect(response.thumbnail[:url]).to eq 'http://www.example.com/images/my-content.png'
    end

    it 'contains the thumbnail_width' do
      expect(response.thumbnail[:width]).to eq 200
    end

    it 'contains the thumbnail_height' do
      expect(response.thumbnail[:height]).to eq 200
    end

    it 'returns nil if thumbnail_url is not in response data' do
      response.attributes['thumbnail_url'] = nil
      expect(response.thumbnail).to be nil
    end
  end

  describe '#embed' do
    it 'returns an embed hash' do
      expect(response.embed).to be_a Hash
    end

    it 'contains the html' do
      expect(response.embed[:html]).to eq '<iframe src="http://www.example.com/embed/my-content" />'
      expect(response.embed.has_key?(:url)).to eq false
    end

    it 'contains the width' do
      expect(response.embed[:width]).to eq 640
    end

    it 'contains the height' do
      expect(response.embed[:height]).to eq 480
    end

    it 'contains the url if html is not present in response data' do
      response.attributes['html'] = nil
      expect(response.embed[:url]).to eq 'http://www.example.com/my/content'
    end
  end
end
