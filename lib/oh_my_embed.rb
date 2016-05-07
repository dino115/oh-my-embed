require 'active_support/all'

Dir.glob(File.join(__dir__, 'oh_my_embed', '*.rb'), &method(:require))
Dir.glob(File.join(__dir__, 'oh_my_embed', '{providers}', '*.rb'), &method(:require))

module OhMyEmbed
  # All OhMyEmbed errors inherits from a generic OhMyEmbed::Error class
  #
  # - OhMyEmbed::UnknownProvider
  # - OhMyEmbed::ProviderNotFound
  # - OhMyEmbed::NotFound
  # - OhMyEmbed::PermissionDenied
  # - OhMyEmbed::FormatNotSupported
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

  class NotFound < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("No embed code for this content (#{url}) found")
    end
  end

  class PermissionDenied < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("You don't have permissions to access the embed code for this content (#{url})")
    end
  end

  class FormatNotSupported < OhMyEmbed::Error # nodoc #
    def self.new(provider_name)
      super("The provider '#{provider_name}' doesn't support json")
    end
  end
end
