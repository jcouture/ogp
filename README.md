# OGP

OGP is a minimalist Ruby library that does only one thing: parse Open Graph protocol information from web sites. For more information: http://ogp.me.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ogp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ogp

## Usage

To keep it very simple, OGP does not perform any HTTP operations. As such, in this example, we use [Faraday](https://github.com/lostisland/faraday) to achieve this functionality.

```ruby
require 'faraday'
require 'ogp'

response = Faraday.get('http://ogp.me')

open_graph = OGP::OpenGraph.new(response.body)
open_graph.title # => "Open Graph protocol"
open_graph.type # => "website"
open_graph.image.url # => "http://ogp.me/logo.png"
open_graph.url # => "http://ogp.me/"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jcouture/ogp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

