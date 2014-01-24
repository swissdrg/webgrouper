require 'net/https'
require 'json'

# decides, which api is tested:
# test => on webgrouper.swissdrg.org
# development => on localhost
ENV_API='development'

# Because I'm too lazy to rewrite the test,
# messages are cropped.
def assert_equal(expected, gotten, message='Error')
  gotten.should eq(expected), "#{gotten} instead of #{expected}, " + message[0,100]
end

def webapi_url(action, env='development')
  if env == 'test'
    url = "https://webgrouper.swissdrg.org/webapi"
  else
    url = "http://localhost:8080/webapi"
  end
  #puts "Connecting to #{url}"
  URI.parse(url + action)
end

def group_as_json(params, env='development')
  url = webapi_url("/grouper/group.json", env)
  req = Net::HTTP::Post.new(url.path)
  req.set_form_data(params)
  http =  Net::HTTP.new(url.host, url.port)
  http.open_timeout = 5000
  http.read_timeout = 5000
  if env == 'test'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.ca_path = '/etc/ssl/certs' if File.exists?('/etc/ssl/certs') # Ubuntu CA files
  end
  before = Time.now
  response = http.request(req)
  after = Time.now
  begin
    r = JSON.parse(response.read_body)
  rescue
    r = response.read_body
  end
  return r, after - before
end