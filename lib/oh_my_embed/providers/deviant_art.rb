module OhMyEmbed
  module Providers
    class DeviantArt < OhMyEmbed::Provider
      # DeviantArt oembed documentation:
      # https://www.deviantart.com/developers/oembed

      self.endpoint = 'http://backend.deviantart.com/oembed'
      self.schemes = [
        '//*.deviantart.com/art/*',
        '//deviantart.com/art/*',
        '//*.deviantart.com/*#/d*',
        '//deviantart.com/*#/d*',
        '//fav.me/*',
        '//*.fav.me/*',
        '//sta.sh/*',
        '//*.sta.sh/*'
      ]
    end
  end
end
