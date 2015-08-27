# encoding: UTF-8

require 'open-uri'
require 'telegram/bot'
require 'oj'
require 'redis'

token = File.read('token.dat')
host = "pub-redis-16230.us-east-1-4.6.ec2.redislabs.com"
port = 16230
redis_pass = File.read('redis_pass.dat')

url_random = "http://127.0.0.1:4567/best"

redis = Redis.new(:host => host, :port => port, :password => redis_pass)