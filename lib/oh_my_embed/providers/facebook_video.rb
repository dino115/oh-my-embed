module OhMyEmbed
  module Providers
    class FacebookVideo < OhMyEmbed::Provider
      # Facebook oembed documentation:
      # https://developers.facebook.com/docs/plugins/oembed-endpoints

      self.endpoint = 'https://www.facebook.com/plugins/video/oembed.json/'
      self.schemes = [
        '//www.facebook.com/*/videos/*',
        '//www.facebook.com/video.php?id=*',
        '//www.facebook.com/video.php?v=*',
      ]
    end
  end
end
