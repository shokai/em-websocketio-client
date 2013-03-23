#!/usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'em-websocketio-client'

name = `whoami`.strip || 'shokai'

EM::run do
  client = EM::WebSocketIO::Client.new('ws://localhost:8080').connect

  client.on :connect do |session|
    puts "connect!! (sessin_id:#{session})"
  end

  client.on :disconnect do
    puts "disconnect websocketio"
  end

  client.on :chat do |data|
    puts "<#{data['name']}> #{data['message']}"
  end

  client.on :error do |err|
    STDERR.puts err
  end

  EM::defer do
    loop do
      line = STDIN.gets.strip
      next if line.empty?
      client.push :chat, {:message => line, :name => name}
    end
  end
end
