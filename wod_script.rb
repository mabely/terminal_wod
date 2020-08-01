# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'HTTParty'
require 'pry'

MERRIAM_WEBSTER_URL = "https://www.merriam-webster.com/word-of-the-day"

def main
  response = scrape_page

  page = Nokogiri::HTML(response)
  return extract_text(page) unless page.nil? 
end

def scrape_page
  response = HTTParty.get(MERRIAM_WEBSTER_URL)
  return "Get request failed" if response.body.nil? || response.body.empty?
  response
end

def extract_text page
  wod = page.css("h1").text
  definition = page.css("div.wod-definition-container").children[3].text
  did_you_know = page.css("div.left-content-box").children[1].text
  return [wod.upcase, definition, did_you_know] 
end


puts main
