# encoding: UTF-8

require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'oj'


def parse_quotes url

	quotes = []

	Nokogiri::HTML(open(url)).css("div[class='quote']").map{ |x| 
		quotes << x.css("div[class='text']").
				children.map{|s| s.name == 'br' ? "\n" : s.text}.join
	}
	quotes.delete nil

	quotes
end

get '/random' do 
	quotes = parse_quotes("http://bash.im/random")

	Oj.dump(quotes.sample)
end

get '/today' do
	Oj.dump(parse_quotes("http://bash.im/best"))
end