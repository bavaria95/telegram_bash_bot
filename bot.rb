# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'
require 'oj'

token = File.read('token.dat')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    
    when '/random'
      bot.api.sendMessage(chat_id: message.chat.id, text: Oj.load(open("http://127.0.0.1:4567/random").read))
    
	else
		bot.api.sendMessage(chat_id: message.chat.id, text: "Unrecognized command")
    end
  end
end
