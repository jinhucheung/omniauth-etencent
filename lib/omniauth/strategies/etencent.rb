module OmniAuth
  module Strategies
    class Etencent < OmniAuth::Strategies::OAuth2
      option :name, 'etencent'

      option :client_options, {
        site: 'https://developers.e.qq.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token',
      }

      option :sandbox, false

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(client_options))
      end

      protected

      def client_options
        options.client_options[:token_url] = "#{api_host}#{options.client_options[:token_url]}" if options.client_options[:token_url] !~ /https?:\/\//
        options.client_options
      end

      def api_host
        options.sandbox ? 'https://sandbox-api.e.qq.com' : 'https://api.e.qq.com'
      end
    end
  end
end

OmniAuth.config.add_camelization 'etencent', 'Etencent'