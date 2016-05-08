module OhMyEmbed
  module Providers
    class Slideshare < OhMyEmbed::Provider
      # Slideshare oembed documentation:
      # http://de.slideshare.net/developers/oembed

      self.endpoint = 'http://www.slideshare.net/api/oembed/2'
      self.schemes = [
        '//slideshare.net/*/*',
        '//*.slideshare.net/*/*',
        '//*.slideshare.net/mobile/*/*',
      ]

      self.custom_mapping = {
        'thumbnail.url' => 'thumbnail'
      }
    end
  end
end
