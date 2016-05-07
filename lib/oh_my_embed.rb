require 'active_support/all'

Dir.glob(File.join(__dir__, 'oh_my_embed', '*.rb'), &method(:require))
Dir.glob(File.join(__dir__, 'oh_my_embed', '{providers}', '*.rb'), &method(:require))

module OhMyEmbed
  # All OhMyEmbed errors inherits from a generic OhMyEmbed::Error class
  #
  # - OhMyEmbed::UnknownProvider
  # - OhMyEmbed::
  # - OhMyEmbed::
  # - OhMyEmbed::
  class Error < StandardError; end

  class UnknownProvider < OhMyEmbed::Error # nodoc #
    def self.new(provider)
      super("Can't register unknown provider '#{provider}'")
    end
  end

  class ProviderNotFound < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("No provider found for given content_url (#{url}). Do you have registered the associated provider?")
    end
  end
end
