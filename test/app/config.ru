require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra'
require 'sinatra/base'
$stdout.sync = true
require 'sinatra/websocketio'
require File.dirname(__FILE__)+'/main'

set :websocketio, :port => ENV['WS_PORT'].to_i

run TestApp
