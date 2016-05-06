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

    # Get a union regex to match the providers url schemes
    #
    # @return [Regexp]
    def self.regex
      regexes = self.schemes.map(&method(:regexify))

      Regexp.union regexes
    end

    # Make a regular expression from an url schema
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
