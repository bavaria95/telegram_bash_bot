# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'
require 'oj'
require 'redis'

token = File.read('token.dat')
host = "pub-redis-16230.us-east-1-4.6.ec2.redislabs.com"
port = 16230
redis_pass = File.read('redis_pass.dat')

redis = Redis.new(:host => host, :port => port, :password => redis_pass)

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text

    when '/start'
    	hints = Telegram::Bot::Types::ReplyKeyboardMarkup
      		.new(keyboard: [%w(Subscribe), %w(Random)])
      	bot.api.sendMessage(chat_id: message.chat.id, text: "Welcome to our Bash bot!\n" +
      		"You can subscribe here on daily digest of quotes or request random quote.", reply_markup: hints)
    
    when 'Random'
      bot.api.sendMessage(chat_id: message.chat.id, text: Oj.load(open("http://127.0.0.1:4567/random").read))
    
    when 'Subscribe'
    	chat_id = message.chat.id
    	if redis.sismember('users', chat_id)
    		bot.api.sendMessage(chat_id: chat_id, text: "You are already subscribed.")
    	else
    		if redis.sadd('users', chat_id)
    			bot.api.sendMessage(chat_id: chat_id, text: "You have been successfully subscribed.")
    			File.open('users.dat', 'a+') { |file| file.write("OK: ADD #{chat_id}\n") }
    		else
    			bot.api.sendMessage(chat_id: chat_id, text: "Sorry, but something went wrong on our end.")
    			File.open('users.dat', 'a+') { |file| file.write("ERROR: ADD #{chat_id}\n") }
    		end
    	end

	else
		bot.api.sendMessage(chat_id: message.chat.id, text: "Unrecognized command")
    end
  end
end
