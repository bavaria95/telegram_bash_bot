# encoding: UTF-8

require 'open-uri'
require 'nokogiri'

url = 'http://bash.im/best'

quotes = Nokogiri::HTML(open(url)).css("div[class='text']").to_a.map{|q| q.children.to_a}