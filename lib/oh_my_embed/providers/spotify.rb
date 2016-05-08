module OhMyEmbed
  module Providers
    class Spotify < OhMyEmbed::Provider
      # Spotify oembed documentation:
      # Spotify has no own documentation in the interwebz :(
      # http://blog.embed.ly/post/45149936446/oembed-for-spotify
      # https://twitter.com/nicklas2k/status/330094611202723840

      self.endpoint = 'https://embed.spotify.com/oembed/'
      self.schemes = [
      '//spotify.com/*',
      '//*.spotify.com/*',
      'spotify:*',
      ]
    end
  end
end
