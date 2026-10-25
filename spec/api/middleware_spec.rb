require 'spec_helper'

describe Api::Middleware do
  include Rack::Test::Methods

  let(:app) { described_class.instance }

  ['/', '/help.html', '/privacy.html'].each do |path|
    it "serves #{path} with versioned assets and private revalidation" do
      get path

      assets = Capybara.string(last_response.body).all('script[src^="/"], img[src^="/"]', visible: :all)
      expect(last_response.status).to eq 200
      expect(last_response.headers['Cache-Control']).to eq 'private, no-cache'
      expect(assets).not_to be_empty
      expect(assets.map { |asset| asset[:src] }).to all(match(/\?v=[a-f0-9]{64}\z/))
    end
  end

  it 'revalidates static assets using their content ETag' do
    get '/scripts/register.js'
    etag = last_response.headers['ETag']
    expect(etag).to eq %("#{Digest::SHA256.file('public/scripts/register.js').hexdigest}")

    get '/scripts/register.js', {}, 'HTTP_IF_NONE_MATCH' => etag
    expect(last_response.status).to eq 304
    expect(last_response.body).to be_empty
  end

  it 'returns current bytes when an old ETag accompanies a matching timestamp' do
    get '/scripts/register.js', {}, 'HTTP_IF_NONE_MATCH' => '"old-content"',
                                    'HTTP_IF_MODIFIED_SINCE' => File.mtime('public/scripts/register.js').httpdate

    expect(last_response.status).to eq 200
    expect(last_response.body).to eq File.read('public/scripts/register.js')
  end
end
