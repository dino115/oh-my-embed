module OhMyEmbed
  ##
  # Provider
  class Provider
    class_attribute :endpoint
    class_attribute :schemes
    class_attribute :mapping

    self.endpoint = nil
    self.mapping = {}
    self.schemes = []

    def self.default_mapping
      {
        'type' => 'type',
        'provider_name' => 'provider_name',
        'provider_url' => 'provider_url',
        'url' => 'url',
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
    #
    # @return [OhMyEmbed::Response]
    def self.fetch(url, params = {})
      uri = URI.parse(self.endpoint)
      uri.query = URI.encode_www_form(params.merge({
        url: url,
        format: 'json',
      }))

      connection = Net::HTTP.new(uri.host, uri.port)
      connection.use_ssl = (uri.port == URI::HTTPS::DEFAULT_PORT)

      begin
        response = connection.get(uri.request_uri)
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
          response_data = JSON.parse(response.body)
      end

      OhMyEmbed::Response.new(self, response_data)
    end

    # Get a union regex to match the providers url schemes
    #
    # @return [Regexp]
    def self.regex
      regexes = self.schemes.map(&method(:regexify))

      Regexp.union regexes
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
  end
end
