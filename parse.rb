# encoding: UTF-8

require 'open-uri'
require 'nokogiri'

url = 'http://bash.im/best'

quotes = {}

Nokogiri::HTML(open(url)).css("div[class='quote']").to_a.map{ |x| 
	quotes[x.css("div.actions a.id").children.text[1..-1]] = x.css("div[class='text']").children.to_a
}

p quotes


