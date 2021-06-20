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
    let(:access_token) { OAuth2::AccessToken.from_hash(client, {}) }

    before do
      allow(subject).to receive(:access_token).and_return(access_token)
      allow(subject).to receive(:raw_info).and_return(raw_info_hash)
    end
  end

  private

  def raw_info_hash
    {
    }
  end
end