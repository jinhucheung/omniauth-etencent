module OmniAuth
  module Strategies
    class Etencent < OmniAuth::Strategies::OAuth2
      option :name, 'etencent'

      option :client_options, {
        site: 'https://developers.e.qq.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token',
        token_method: :get
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

      uid { access_token['account_id'] }

      info do
        access_token.to_hash.slice(
          'account_uin',
          'account_id',
          'scope_list',
          'wechat_account_id',
          'account_role_type',
          'account_type',
          'role_type'
        )
      end

      extra do
        {
          raw_info: raw_info,
          scope: scope
        }
      end

      def raw_info
        @raw_info ||= access_token.get("#{api_host}/advertiser/get", params: { account_id: access_token['account_id'] }).parsed
      end

      def scope
        access_token['scope']
      end

      protected

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(client_options))
      end

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