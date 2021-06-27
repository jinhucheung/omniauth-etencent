module OmniAuth
  module Strategies
    class Etencent < OmniAuth::Strategies::OAuth2
      option :name, 'etencent'

      option :client_options, {
        site: 'https://developers.e.qq.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token',
        token_method: :get,
        extract_access_token: ::OmniAuth::Etencent::AccessToken
      }

      option :authorize_options, %i[scope state account_type account_display_number]

      option :sandbox, false

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
              # to support omniauth-oauth2's auto csrf protection
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end
        end
      end

      uid { authorizer_info['account_id'] }

      info do
        authorizer_info
      end

      credentials do
        hash = {'token' => access_token.token}
        hash['refresh_token'] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
        hash['expires_at'] = access_token.expires_at if access_token.expires?
        hash['expires'] = access_token.expires?
        hash['refresh_token_expires_at'] = access_token['refresh_token_expires_at'] if access_token['refresh_token_expires_at'].present?
        hash
      end

      extra do
        {
          scope: scope
        }
      end

      def authorizer_info
        @authorizer_info ||= access_token.to_hash.dig('authorizer_info') || {}
      end

      def scope
        authorizer_info['scope_list']
      end

      protected

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(client_options))
      end

      def client_options
        options.client_options[:token_url] = "#{api_base_url}#{options.client_options[:token_url]}" if options.client_options[:token_url] !~ /https?:\/\//
        options.client_options
      end

      def api_base_url
        options.sandbox ? 'https://sandbox-api.e.qq.com' : 'https://api.e.qq.com'
      end
    end
  end
end

OmniAuth.config.add_camelization 'etencent', 'Etencent'