module OhMyEmbed
  module Providers
    class Instagram < OhMyEmbed::Provider
      # Instagram oembed documentation:
      # https://www.instagram.com/developer/embedding/?hl=de#oembed

      self.endpoint = 'https://api.instagram.com/oembed/'
      self.schemes = [
        '//instagr.am/p/*',
        '//instagram.com/p/*',
        '//*.instagram.com/p/*',
      ]
    end
  end
end
