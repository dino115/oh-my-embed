module OhMyEmbed
  class Response
    attr_reader :attributes
    attr_reader :provider

    delegate :mapping, to: :provider

    # Initialize the OhMyEmbed::Response
    #
    # @param [OhMyEmbed::Provider] provider
    # @param [String] url
    # @param [Hash] data
    def initialize(provider, url, data = {})
      @provider = provider
      @url = url
      @attributes = data
    end

    # Get a single attribute from the raw response
    #
    # @param [String|Symbol] field_name
    # @return [mixed]
    def attribute(field_name)
      @attributes.fetch(field_name.to_s, nil)
    end

    # Get the oembed type of the response
    #
    # @return [String] one of :photo, :video, :rich, :link
    def type
      attribute(mapping['type']).to_sym
    end

    # Get the oembed provider name
    #
    # @return [String]
    def provider_name
      attribute(mapping['provider_name']) || @provider.provider_name
    end

    # Get the provider url
    #
    # @return [String]
    def provider_url
      attribute(mapping['provider_url']) || @provider.endpoint
    end

    # Get the content url
    #
    # @return [String]
    def url
      attribute(mapping['url']) || @url
    end

    # Get the title
    #
    # @return [String]
    def title
      attribute(mapping['title'])
    end

    # Get the author informations
    #
    # @return [Hash] :name, :url
    def author
      author_name = attribute(mapping['author.name'])
      author_url = attribute(mapping['author.url'])

      if author_name || author_url
        {
          name: author_name,
          url: author_url,
        }.compact
      else
        nil
      end
    end

    # Get the thumbnail informations
    #
    # @return [Hash] :url, :width, :height
    def thumbnail
      thumbnail_url = attribute(mapping['thumbnail.url'])

      if thumbnail_url
        {
          url: thumbnail_url,
          width: attribute(mapping['thumbnail.width']),
          height: attribute(mapping['thumbnail.height']),
        }
      else
        nil
      end
    end

    # Get the embed informations
    #
    # @return [Hash] :html, :width, :height
    def embed
      html = attribute(mapping['embed.html'])

      {
        html: html,
        url: html ? nil : url,
        width: attribute(mapping['embed.width']),
        height: attribute(mapping['embed.height']),
      }.compact
    end

    # Return the Hash representation of this response
    #
    # @return [Hash] :type, :provider_name, :provider_url, :url, :author, :thumbnail, :embed
    def to_h
      %i{ type provider_name provider_url url title author thumbnail embed }.map do |key|
        [key, self.send(key)]
      end.to_h
    end
  end
end
