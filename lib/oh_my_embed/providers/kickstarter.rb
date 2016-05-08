module OhMyEmbed
  module Providers
    class Kickstarter < OhMyEmbed::Provider
      # Kickstarter oembed documentation:
      # Kickstarter has no own documentation in the interwebz :(
      # http://oembed.com/providers.json

      self.endpoint = 'https://www.kickstarter.com/services/oembed'
      self.schemes = [
        '//kickstarter.com/projects/*',
        '//*.kickstarter.com/projects/*',
      ]
    end
  end
end
