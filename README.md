em-websocketio-client
=====================
[Sinatra WebSocketIO](https://github.com/shokai/sinatra-websocketio) Client for eventmachine

* https://github.com/shokai/em-websocketio-client

Installation
------------

    % gem install em-websocketio-client


Usage
-----

```ruby
require 'eventmachine'
require 'em-websocketio-client'

EM::run do
  client = EM::WebSocketIO::Client.new('ws://localhost:8080').connect

  client.on :connect do |session|
    puts "connect!! (sessin_id:#{session})"
  end

  client.on :disconnect do
    puts "disconnect websocketio"
  end

  client.on :error do |err|
    STDERR.puts err
  end

  ## regist receive "chat" event
  client.on :chat do |data|
    puts "#{data['name']} - #{data['message']}"
  end

  ## push "chat" event to Server
  EM::add_periodic_timer 10 do
    client.push :chat, {:message => Time.now.to_s, :name => 'clock'}
  end
end
```


Sample
------

start [chat server](https://github.com/shokai/websocketio-chat-sample)

    % git clone git://github.com/shokai/websocketio-chat-sample.git
    % cd websocketio-chat-sample
    % bundle install
    % foreman start

=> http://localhost:5000


sample chat client

    % ruby sample/cui_chat_client.rb


Test
----

    % gem install bundler
    % bundle install
    % export PORT=5000
    % export WS_PORT=8080
    % export PID_FILE=/tmp/em-websocketio-client-testapp.pid
    % rake test


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
