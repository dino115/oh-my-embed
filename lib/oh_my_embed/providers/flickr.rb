module OhMyEmbed
  module Providers
    class Flickr < OhMyEmbed::Provider
      # Flickr oembed documentation:
      # Flickr has no own documentation in the interwebz :(
      # http://oembed.com/providers.json

      self.endpoint = 'https://www.flickr.com/services/oembed/'
      self.schemes = [
        '//*.flickr.com/*',
        '//flic.kr/*',
      ]
    end
  end
end
