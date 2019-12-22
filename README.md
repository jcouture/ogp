<p align="center">
  <a href="https://github.com/jcouture/ogp">
    <img src="https://i.imgur.com/qZrMsLq.png" alt="ogp" />
  </a>
  <br />
  OGP is a minimalist Ruby library that does only one thing: parse Open Graph protocol information. For more information: <a href="http://ogp.me">http://ogp.me</a>.
  <br /><br />
  <a href="https://rubygems.org/gems/ogp"><img src="http://img.shields.io/gem/v/ogp.svg" /></a>
  <a href="https://travis-ci.org/jcouture/ogp"><img src="http://img.shields.io/travis/jcouture/ogp.svg" /></a>
</p>


## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'ogp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ogp

## Usage

In order to keep OGP very simple, it does not perform any HTTP operations. As such, in this example, [Faraday](https://github.com/lostisland/faraday) is used to achieve this functionality.

```ruby
require 'faraday'
require 'ogp'

response = Faraday.get('http://ogp.me')

open_graph = OGP::OpenGraph.new(response.body)
open_graph.title # => "Open Graph protocol"
open_graph.type # => "website"
open_graph.image.url # => "http://ogp.me/logo.png"
open_graph.url # => "http://ogp.me/"

# All open graph tags are additionally stored in a `data` hash so that custom
# open graph tags can still be accessed.
open_graph.data["title"] # => "Open Graph protocol"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jcouture/ogp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

The OGP pirate logo is based on [this icon](https://thenounproject.com/term/pirate/9414/) by [Simon Child](https://thenounproject.com/Simon%20Child/), from the Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.
