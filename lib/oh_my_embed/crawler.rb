module OhMyEmbed
  class Crawler
    attr_reader :providers

    # Initialize the OhMyEmbed::Crawler
    #
    # @param *providers [Symbol|OhMyEmbed::Provider|Hash] the providers to register or options as the last argument
    def initialize(*providers)
      @providers = Set.new

      options = providers.extract_options!

      register_all_built_in_providers if options[:all]
      providers.each do |provider|
        register provider
      end
    end

    # Register a provider
    #
    # @param provider [Symbol|OhMyEmbed::Provider]
    # @raise [OhMyEmbed::UnknownProvider] if you try to register an unknown provider
    def register(provider)
      if provider.is_a? Symbol
        begin
          provider = OhMyEmbed::Providers.const_get(provider.to_s.classify)
        rescue NameError
          raise OhMyEmbed::UnknownProvider.new(provider)
        end
      end

      @providers.add provider
    end

    # Register all built-in providers for this crawler
    #
    def register_all_built_in_providers
      built_in_providers.each do |provider|
        register provider
      end
    end

    # Fetch the embed response for the given content_url
    #
    # @param [String] content_url
    # @return [OhMyEmbed::Response]
    def fetch(content_url)
      provider = self.provider_for(content_url)
      provider.fetch(content_url)
    end

    # Get the provider for given content_url
    #
    # @param [String] content_url
    # @raise [OhMyEmbed::UnknownProvider] if no registered provider matches the given context_url
    # @return [OhMyEmbed::Provider]
    def provider_for(content_url)
      @providers.find{ |provider| provider.regex =~ content_url } || raise(OhMyEmbed::ProviderNotFound.new(content_url))
    end

    # Check if any provider matches the given content_url
    #
    # @param [String] content_url
    # @return [true|false]
    def embeddable?(content_url)
      @providers.any?{ |provider| provider.regex =~ content_url }
    end

    # Select all provider constants from the OhMyEmbed::Providers module
    #
    # @return [Array<Symbol>]
    def built_in_providers
      OhMyEmbed::Providers.constants
        .select { |c| OhMyEmbed::Providers.const_get(c) < OhMyEmbed::Provider }
    end
  end
end
