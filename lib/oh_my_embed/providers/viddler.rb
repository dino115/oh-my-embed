module OhMyEmbed
  module Providers
    class Viddler < OhMyEmbed::Provider
      # Viddler oembed documentation:
      # http://developers.viddler.com/#liverail-integration

      self.endpoint = 'http://www.viddler.com/oembed/'
      self.schemes = [
        '//www.viddler.com/v/*',
      ]

      self.custom_mapping = {
        'author.name' => 'author_name ',
      }
    end
  end
end
