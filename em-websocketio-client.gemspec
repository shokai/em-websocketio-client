# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-websocketio-client/version'

Gem::Specification.new do |spec|
  spec.name          = "em-websocketio-client"
  spec.version       = EventMachine::WebSocketIO::Client::VERSION
  spec.authors       = ["Sho Hashimoto"]
  spec.email         = ["hashimoto@shokai.org"]
  spec.description   = %q{Sinatra WebSocketIO client for eventmachine}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/shokai/em-websocketio-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "sinatra-websocketio"
  spec.add_development_dependency "thin"

  spec.add_dependency "em-websocket-client"
  spec.add_dependency "event_emitter"
end
