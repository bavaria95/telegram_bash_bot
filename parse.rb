# encoding: UTF-8

require 'open-uri'
require 'nokogiri'

url = 'http://bash.im/best'

quotes = {}

Nokogiri::HTML(open(url)).css("div[class='quote']").map{ |x| 
	quotes[x.css("div.actions a.id").children.text[1..-1]] = x.css("div[class='text']").
			children.map{|s| s.name == 'br' ? '\n' : s.text}.join
}
quotes.delete nil