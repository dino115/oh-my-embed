module OhMyEmbed
  module Providers
    class Youtube < OhMyEmbed::Provider
      # Youtube oembed documentation:
      # Youtube has no own documentation in the interwebz :(
      # http://uber-rob.co.uk/2014/05/youtube-oembed-documentation/
      # http://oembed.com/providers.json

      self.endpoint = 'https://www.youtube.com/oembed'
      self.schemes = [
        '//youtube.com/*',
        '//*.youtube.com/*',
        '//youtu.be/*',
        '//*.youtu.be/*',
      ]
    end
  end
end
