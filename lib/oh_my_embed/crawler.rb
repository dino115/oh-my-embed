module OhMyEmbed
  class Crawler
    attr_reader :providers

    # @providers = [ OhMyEmbed::Provider::Youtube ]
    #
    # provider = @providers.find{ |p| p.regex =~ url_to_embed }
    # provider.fetch()

    # Initialize crawler
    #
    # @param *providers [Symbol|OhMyEmbed::Provider] the providers to register
    def initialize(*providers)
      @providers = []

      providers.each do |provider|
        register provider
      end
    end

    # Register an oembed provider
    #
    # @param provider [Symbol|OhMyEmbed::Provider]
    def register(provider)
      if provider.is_a? Symbol
        provider = "OhMyEmbed::Providers::#{provider.to_s.classify}".constantize
      end

      @providers << provider
    end
  end
end
