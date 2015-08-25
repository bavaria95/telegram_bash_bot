# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'telegram/bot'

def get_random_quote

	url = 'http://bash.im/random'

	quotes = {}

	Nokogiri::HTML(open(url)).css("div[class='quote']").map{ |x| 
		quotes[x.css("div.actions a.id").children.text[1..-1]] = x.css("div[class='text']").
				children.map{|s| s.name == 'br' ? "\n" : s.text}.join
	}
	quotes.delete nil

	quotes[quotes.keys.sample]
end

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
