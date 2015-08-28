# encoding: UTF-8

require 'open-uri'
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

url_today = "http://127.0.0.1:4567/today"

redis = Redis.new(:host => host, :port => port, :password => redis_pass)


quotes = parse_url(url_today)
subscribed_users = redis.smembers('users')

Telegram::Bot::Client.run(token) do |bot|
	subscribed_users.each do |user|
		quotes.each do |quote|
			bot.api.sendMessage(chat_id: user, text: quote, 
					reply_markup: custom_keyboard(redis, user))
		end
	end

end