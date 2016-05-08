module OhMyEmbed
  module Providers
    class FacebookPost < OhMyEmbed::Provider
      # Facebook oembed documentation:
      # https://developers.facebook.com/docs/plugins/oembed-endpoints

      self.endpoint = 'https://www.facebook.com/plugins/post/oembed.json/'
      self.schemes = [
        '//www.facebook.com/*/posts/*',
        '//www.facebook.com/*/activity/*',
        '//www.facebook.com/photo.php?fbid=*',
        '//www.facebook.com/photos/*',
        '//www.facebook.com/permalink.php?story_fbid=*',
        '//www.facebook.com/media/set?set=*',
        '//www.facebook.com/questions/*',
        '//www.facebook.com/notes/*/*/*',
      ]
    end
  end
end
