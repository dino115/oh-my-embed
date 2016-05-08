OhMyEmbed
=================
VERSION BADGE
[![Build Status](https://travis-ci.org/dino115/oh-my-embed.svg?branch=master)](https://travis-ci.org/dino115/oh-my-embed)
[![Code Climate](https://codeclimate.com/github/dino115/oh-my-embed/badges/gpa.svg)](https://codeclimate.com/github/dino115/oh-my-embed)
[![Test Coverage](https://codeclimate.com/github/dino115/oh-my-embed/badges/coverage.svg)](https://codeclimate.com/github/dino115/oh-my-embed/coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/dino115/oh-my-embed.svg)](https://gemnasium.com/github.com/dino115/oh-my-embed)

Simple gem to interact with oembed providers. Read specs at http://www.oembed.com

** WORK IN PROGRESS, not finshed yet **

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oh-my-embed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oh-my-embed

## Build in providers

- Youtube
- Slideshare
- Instagram
- Twitter
- Facebook (Posts)
- Facebook (Videos)
- Flickr
- SoundCloud
- Kickstarter
- Spotify

If you need some other providers feel free to add them via pull request or build it for your application only by using the `OhMyEmbed::Provider` base class.
See the custom provider section for more informations.

## Usage

### Basics
First of all you have to create a `OhMyEmbed::Crawler` object and register your desired providers.
You can use all build-in providers, select only a few or mix them up with your custom providers.

```ruby
# Crawler with all build-in providers (includes all classes you added to the OhMyEmbed::Providers module)
crawler = OhMyEmbed::Crawler.new(all: true)

# Crawler with specific providers
crawler = OhMyEmbed::Crawler.new(:youtube, :slideshare)

# Crawler with custom providers
crawler = OhMyEmbed::Crawler.new(:youtube, MyProvider)

# Crawler with all build-in and a custom provider
crawler = OhMyEmbed::Crawler.new(MyProvider, all: true)
```

Now you can crawl for your embed code easily with the `fetch` method and get an `OhMyEmbed::Response` object.

```ruby
result = crawler.fetch('https://www.youtube.com/watch?v=EErY75MXYXI')

# with additional options, piped as parameter to the endpoint
result = crawler.fetch('https://www.youtube.com/watch?v=EErY75MXYXI', autoplay: 1)
```

You also can also ask if the url matches an registered url schema or get the provider.

```ruby
# check if url is embeddable
crawler.embeddable?('https://www.youtube.com/watch?v=EErY75MXYXI') # => true

# get the provider class
crawler.provider_for('https://www.youtube.com/watch?v=EErY75MXYXI') # => OhMyEmbed::Providers::Youtube
```

If you want use only a single provider, then you can perform your fetch action directly on the provider too.

```ruby
OhMyEmbed::Providers::Youtube.fetch('https://www.youtube.com/watch?v=EErY75MXYXI')
```

### Response handling
With a response object you have access to all oembed fields, described in http://oembed.com/#section2

To access the raw response you can use the the `attribute` method.

```ruby
response.attributes # return all raw attributes as hash
response.attribute(:thumbnail_url) # get a single attribute from the raw response
```

A response object provides an easy interface to the different response types and provider specific fields. (i.e. slideshare provides a thumbnail field instead of thumbnail_url)

 ```ruby
 response.type # [Symbol] one of :photo, :video, :link, :rich
 response.provider # [OhMyEmbed::Provider]
 response.provider_name # [String] Provider name from response or readable class name
 response.provider_url # [String|nil]
 response.url # [String] The provided url or original url
 response.author # [Hash|nil] { name: [String], url: [String] }
 response.thumbnail # [Hash|nil] { url: [String|nil], width: [Float], height: [Float] }
 response.embed # [Hash] { html: [String|nil] Some html embed code, url: [String|nil], width: [Float|nil], height: [Float|nil] }
 ```

### Error handling
The gem can raise the following errors. All of them are subclasses of a generic `OhMyEmbed::Error` class.

- *OhMyEmbed::UnknownProvider* when you try to register an unknown provider
- *OhMyEmbed::ProviderNotFound* when no provider matches the schema of given content url
- *OhMyEmbed::NotFound* when the endpoint returns with 404 not found
- *OhMyEmbed::PermissionDenied* when the endpoint returns with 401 unauthorized
- *OhMyEmbed::FormatNotSupported* when the endpoint returns with 501 not implemented
- *OhMyEmbed::ParseError* when the parser failed, i.e. the responded json is malformed

### Custom providers
You can create your own provider class by extending the `OhMyEmbed::Provider` base class.

```ruby
class MyProvider < OhMyEmbed::Provider
  # The oembed endpoint must be specified
  self.endpoint = 'https://www.example.com/oembed'

  # The oembed url schemes must be specified, they are used for easy lookup
  self.schemes = [
    '//example.com/content/*'
  ]

  # Optional you can define the provider name, if not specified, the name will extracted from the class name
  self.provider_name = 'My Provider'

  # Optional you can use a custom mapping for the response, if your provider doesn't stick to the specification :(
  # this merges with the default mapping, so you must only set the divergent mapping
  self.custom_mapping = {
    'thumbnail.url' => 'thumbnail'
  }
end
```

## Format
Currently the gem supports only json as response format.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dino115/oh-my-embed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

