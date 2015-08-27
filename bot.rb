# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'
require 'oj'
require 'redis'

token = File.read('token.dat')
redis_pass = File.read('redis_pass.dat')

redis = Redis.new(:host => "pub-redis-16230.us-east-1-4.6.ec2.redislabs.com", :port => 16230, :password => redis_pass)

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    
    when '/random'
      bot.api.sendMessage(chat_id: message.chat.id, text: Oj.load(open("http://127.0.0.1:4567/random").read))
    
    when '/subscribe'
    	chat_id = message.chat.id
    	if redis.sismember('users', chat_id)
    		bot.api.sendMessage(chat_id: message.chat.id, text: "You are already subscribed")
    	else
    		redis.sadd('users', chat_id)
    		File.open('users.dat', 'a+') { |file| file.write("OK: ADD #{chat_id}\n") }
    	end

	else
		bot.api.sendMessage(chat_id: message.chat.id, text: "Unrecognized command")
    end
  end
end
