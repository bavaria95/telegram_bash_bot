# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'

token = File.read('token.dat')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    
    when '/random'
      bot.api.sendMessage(chat_id: message.chat.id, text: get_random_quote)
    
	else
		bot.api.sendMessage(chat_id: message.chat.id, text: "Unrecognized command")
    end
  end
end
