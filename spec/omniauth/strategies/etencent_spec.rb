RSpec.describe OmniAuth::Strategies::Etencent do
  let(:client) { OAuth2::Client.new('client_id', 'client_secret') }
  let(:app) { -> { [200, {}, ['Hello.']] } }
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }

  subject do
    OmniAuth::Strategies::Etencent.new(app, 'client_id', 'client_secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  context '#client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('etencent')
    end

    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://developers.e.qq.com')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('/oauth/token')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('/oauth/authorize')
    end
  end

  context '#info' do
    let(:access_token) { OmniAuth::Etencent::AccessToken.from_hash(client, access_token_hash) }

    before do
      allow(subject).to receive(:access_token).and_return(access_token)
    end

    it 'should return the account id' do
      expect(subject.uid).to eq(access_token_hash.dig('data', 'authorizer_info', 'account_id'))
    end

    it 'should return the authorizer info' do
      expect(subject.info).to eq(access_token_hash.dig('data', 'authorizer_info'))
    end
  end

  private

  def access_token_hash
    {
      "code" => 0,
      "message" => "",
      "message_cn" => "",
      "data" => {
        "authorizer_info" => {
          "account_uin" => 2644750491,
          "account_id" =>  2947221,
          "scope_list" => [
            "ads_management",
            "ads_insights",
            "account_management",
            "audience_management",
            "user_actions"
          ],
          "wechat_account_id" => "spid1234567890",
          "account_role_type" => "ACCOUNT_ROLE_TYPE_AGENCY"
        },
        "access_token" => "<ACCESS_TOKEN>",
        "refresh_token" => "<REFRESH_TOKEN>",
        "access_token_expires_in" => 86400,
        "refresh_token_expires_in" => 2592000
      }
    }
  end
end