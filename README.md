[![Gem Version](https://badge.fury.io/rb/omniauth-etencent.svg)](https://badge.fury.io/rb/omniauth-etencent)
[![Build Status](https://github.com/jinhucheung/omniauth-etencent/actions/workflows/main.yml/badge.svg)](https:/github.com/jinhucheung/omniauth-etencent/actions)

# Omniauth Etencent

This is the official OmniAuth strategy for authenticating to Tencent Marketing. To use it, you'll need to sign up for an OAuth2 Application ID and Secret on the [Tencent Marketing Applications Page](https://developers.e.qq.com/app).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-etencent'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install omniauth-etencent
```

## Usage

`OmniAuth::Strategies::Etencent` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :etencent, ENV['ETENCENT_CLIENT_ID'], ENV['ETENCENT_CLIENT_SECRET']
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jinhucheung/omniauth-etencent.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
