# encoding: UTF-8

require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

def parse_quotes url

	quotes = {}

	Nokogiri::HTML(open(url)).css("div[class='quote']").map{ |x| 
		quotes[x.css("div.actions a.id").children.text[1..-1]] = x.css("div[class='text']").
				children.map{|s| s.name == 'br' ? "\n" : s.text}.join
	}
	quotes.delete nil

	quotes
end

get '/random' do 
	quotes = parse_quotes("http://bash.im/random")
	quotes[quotes.keys.sample].to_json
end

get '/today' do
	parse_quotes("http://bash.im/best").to_json
end