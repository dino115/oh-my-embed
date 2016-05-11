module OhMyEmbed
  module Providers
    class Dailymotion < OhMyEmbed::Provider
      # Dailymotion oembed documentation:
      # https://developer.dailymotion.com/player

      self.endpoint = 'https://www.dailymotion.com/services/oembed'
      self.schemes = [
        '//dailymotion.com/video/*',
        '//*.dailymotion.com/video/*',
      ]
    end
  end
end
