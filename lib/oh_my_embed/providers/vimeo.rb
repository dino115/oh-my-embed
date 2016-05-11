module OhMyEmbed
  module Providers
    class Vimeo < OhMyEmbed::Provider
      # Vimeo oembed documentation:
      # https://developer.vimeo.com/apis/oembed

      self.endpoint = 'https://vimeo.com/api/oembed.json'
      self.schemes = [
        '//vimeo.com/*',
        '//*.vimeo.com/*',
        '//vimeo.com/channels/*/*',
        '//*.vimeo.com/channels/*/*',
        '//vimeo.com/groups/*/videos/*',
        '//*.vimeo.com/groups/*/videos/*',
      ]
    end
  end
end
