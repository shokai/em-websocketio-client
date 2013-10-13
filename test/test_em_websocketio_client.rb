require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestEmWebSocketIOClient < MiniTest::Test

  def test_simple
    post_data = {:time => Time.now.to_s, :msg => 'hello!!'}
    res = nil

    EM::run do
      client = EM::WebSocketIO::Client.new(App.websocketio_url).connect
      client.on :broadcast do |data|
        res = data
        client.close
        EM::add_timer 1 do
          EM::stop
        end
      end

      client.on :connect do |session|
        push :broadcast, post_data
      end

      client.on :error do |err|
        EM::add_timer 1 do
          EM::stop
        end
      end
    end

    assert res != nil, 'server not respond'
    assert res["time"] == post_data[:time]
    assert res["msg"] == post_data[:msg]
  end

  def test_client_to_client2
    ## client --> server --> client2
    post_data = {:time => Time.now.to_s, :msg => 'hello!!', :to => nil}
    res = nil
    res2 = nil
    EM::run do
      client = EM::WebSocketIO::Client.new(App.websocketio_url).connect
      client.on :message do |data|
        res = data
      end

      client.on :error do |err|
        EM::add_timer 1 do
          EM::stop
        end
      end

      client.on :connect do |session|
        client2 = EM::WebSocketIO::Client.new(App.websocketio_url).connect
        client2.on :error do |err|
          EM::add_timer 1 do
            EM::stop
          end
        end
        client2.on :connect do |session2|
          post_data['to'] = session2
          client.push :message, post_data
        end
        client2.on :message do |data|
          res2 = data
          client2.close
          client.close
          EM::add_timer 1 do
            EM::stop
          end
        end
      end

    end

    assert res2 != nil, 'server not respond'
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
    assert res == nil
  end


  def test_broadcast
    ## client --> server --> client&client2
    post_data = {:time => Time.now.to_s, :msg => 'hello!!'}
    res = nil
    res2 = nil
    EM::run do
      client = EM::WebSocketIO::Client.new(App.websocketio_url).connect
      client.on :broadcast do |data|
        res = data
        client.close
      end

      client.on :error do |err|
        EM::add_timer 1 do
          EM::stop
        end
      end

      client.on :connect do |session|
        client2 = EM::WebSocketIO::Client.new(App.websocketio_url).connect
        client2.on :error do |err|
          EM::add_timer 1 do
            EM::stop
          end
        end
        client2.on :connect do |session2|
          client.push :broadcast, post_data
        end
        client2.on :broadcast do |data|
          res2 = data
          client2.close
          EM::add_timer 1 do
            EM::stop
          end
        end
      end

    end
    assert res != nil, 'server not respond'
    assert res["time"] == post_data[:time]
    assert res["msg"] == post_data[:msg]
    assert res2 != nil
    assert res2["time"] == post_data[:time]
    assert res2["msg"] == post_data[:msg]
  end

end
