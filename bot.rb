# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'
require 'oj'
require 'redis'

def custom_keyboard(redis, id)
	if redis.sismember('users', id)
			hints = Telegram::Bot::Types::ReplyKeyboardMarkup
				.new(keyboard: [%w(Random)])
	else
		hints = Telegram::Bot::Types::ReplyKeyboardMarkup
		.new(keyboard: [%w(Subscribe), %w(Random)])
	end

	hints
end

def parse_url url
	Oj.load(open(url).read)
end

token = File.read('token.dat')
host = "pub-redis-16230.us-east-1-4.6.ec2.redislabs.com"
port = 16230
redis_pass = File.read('redis_pass.dat')

redis = Redis.new(:host => host, :port => port, :password => redis_pass)


Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text

    when '/start'
      	bot.api.sendMessage(chat_id: message.chat.id, text: "Welcome to our Bash bot!\n" +
      		"You can subscribe here on daily digest of quotes or request random quote.", 
      		reply_markup: custom_keyboard(redis, message.chat.id))
    
    when 'Random'
      	bot.api.sendMessage(chat_id: message.chat.id, reply_markup: custom_keyboard(redis, message.chat.id), 
      		text: parse_url("http://127.0.0.1:4567/random"))
    
	when 'Subscribe'
		chat_id = message.chat.id

		if redis.sadd('users', chat_id)
			bot.api.sendMessage(chat_id: chat_id, text: "You have been successfully subscribed.", 
				reply_markup: custom_keyboard(redis, message.chat.id))
			File.open('users.dat', 'a+') { |file| file.write("OK: ADD #{chat_id}\n") }
		else
			bot.api.sendMessage(chat_id: chat_id, text: "You are already subscribed.",
				reply_markup: custom_keyboard(redis, message.chat.id))
		end
	else
		bot.api.sendMessage(chat_id: message.chat.id, text: "Unrecognized command", 
			reply_markup: custom_keyboard(redis, message.chat.id))
    end
  end
end
