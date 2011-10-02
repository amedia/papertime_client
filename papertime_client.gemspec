Gem::Specification.new do |s|
  s.name        = 'papertime_client'
  s.version     = '0.0.1'
  s.date        = '2011-10-01'
  s.summary     = "For talking to Papertime server"
  s.description = "Papertime is a server giving details about Norwegian newspapers. This is a client for connecting to that server."
  s.authors     = ["Origogruppen AS"]
  s.email       = 'post@origo.no'
  s.files       = ["lib/papertime_client.rb"]
  s.homepage    =
    'http://rubygems.org/gems/papertime_client'

  s.add_runtime_dependency 'httpclient'
  s.add_runtime_dependency 'json'

  s.add_development_dependency "rspec"
end
