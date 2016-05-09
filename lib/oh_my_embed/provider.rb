module OhMyEmbed
  ##
  # Provider
  class Provider
    class_attribute :provider_name
    class_attribute :endpoint
    class_attribute :schemes
    class_attribute :custom_mapping

    self.provider_name = nil
    self.endpoint = nil
    self.custom_mapping = {}
    self.schemes = []

    def self.default_mapping
      {
        'type' => 'type',
        'provider_name' => 'provider_name',
        'provider_url' => 'provider_url',
        'url' => 'url',
        'title' => 'title',
        'author.name' => 'author_name',
        'author.url' => 'author_url',
        'thumbnail.url' => 'thumbnail_url',
        'thumbnail.width' => 'thumbnail_width',
        'thumbnail.height' => 'thumbnail_height',
        'embed.html' => 'html',
        'embed.width' => 'width',
        'embed.height' => 'height',
      }
    end

    # Fetch the embed result for the provider content
    #
    # @param [String] url
    # @param [Hash] params
    #
    # @raise [OhMyEmbed::Error] on request timeout
    # @raise [OhMyEmbed::PermissionDenied] on request status 401
    # @raise [OhMyEmbed::NotFound] on request status 404
    # @raise [OhMyEmbed::FormatNotSupported] on request status 501
    # @raise [OhMyEmbed::ParseError] on parsing error
    #
    # @return [OhMyEmbed::Response]
    def self.fetch(url, params = {})
      uri = URI.parse(self.endpoint)
      uri.query = URI.encode_www_form(params.merge({
        url: url,
        format: 'json',
      }))

      begin
        response = Net::HTTP.get_response(uri)
      rescue Timeout::Error
        raise OhMyEmbed::Error.new('Request timed out')
      end

      case response
        when Net::HTTPUnauthorized
          raise OhMyEmbed::PermissionDenied.new(url)
        when Net::HTTPNotFound
          raise OhMyEmbed::NotFound.new(url)
        when Net::HTTPNotImplemented
          raise OhMyEmbed::FormatNotSupported.new(self.name)
        when Net::HTTPOK
          begin
            response_data = JSON.parse(response.body)
          rescue
            raise OhMyEmbed::ParseError.new(self.name, url, response.body)
          end
      end

      OhMyEmbed::Response.new(self, url, response_data)
    end

    # Get a union regex to match the providers url schemes
    #
    # @return [Regexp]
    def self.regex
      @_regex ||= begin
        regexes = self.schemes.map(&method(:regexify))
        Regexp.union regexes
      end
    end

    # Create a regular expression from an url schema, does nothing if the schema is already a Regexp
    #
    # @param [String|Regexp] schema
    # @return [Regexp]
    def self.regexify(schema)
      if schema.is_a? Regexp
        schema
      else
        schema = "(https:|http:)#{schema}" unless schema.start_with?('http')
        Regexp.new("^#{schema.gsub('.', '\.').gsub('*', '(.*?)')}$", Regexp::IGNORECASE)
      end
    end

    # Get the mapping hash, defaults merged with the custom mapping
    #
    # @return [Hash]
    def self.mapping
      @_mapping ||= self.default_mapping.merge(self.custom_mapping)
    end

    # Get the provider name
    #
    # @return [String]
    def self.provider_name
      instance_variable_get('@provider_name') || self.name.split('::').last
    end
  end
end
