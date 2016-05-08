module OhMyEmbed
  module Providers
    class Twitter < OhMyEmbed::Provider
      # Twitter oembed documentation:
      # https://dev.twitter.com/rest/reference/get/statuses/oembed

      self.endpoint = 'https://publish.twitter.com/oembed'
      self.schemes = [
        '//twitter.com/*/status/*',
        '//*.twitter.com/*/status/*',
      ]
    end
  end
end
