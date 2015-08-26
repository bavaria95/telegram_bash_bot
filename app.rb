# encoding: UTF-8

require 'sinatra'
require 'open-uri'
require 'nokogiri'

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


get '/random' do 
	get_random_quote
end