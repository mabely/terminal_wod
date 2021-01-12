#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

MERRIAM_WEBSTER_URL = "https://www.merriam-webster.com/word-of-the-day".freeze

def main
  page = Nokogiri::HTML.parse(open(MERRIAM_WEBSTER_URL))
  raise StandardError, "Error: Empty response from #{MERRIAM_WEBSTER_URL}" if page.nil?

  contents = extract_text(page)
  contents.each {|def_section| $stdout.puts(def_section) }

rescue SocketError => e
  $stderr.puts "SocketError: Get request failed, please check URL.\n\r#{e.inspect}"
  abort
rescue HTTParty::Error => e
  $stderr.puts "Some HTTParty error: #{e}"
  abort
end

def extract_text page
  wod = page.css("h1").text
  definition = page.css("div.wod-definition-container").children[3].text
  did_you_know = page.css("div.left-content-box").children[1].text
  return ["\n", "=== #{wod.upcase} ===", "\n", format_def(definition), "\n", did_you_know, "\n\n"] 
end

def format_def definition
  definition.split(" :").map(&:chomp).join(",")
end

main if __FILE__ == $PROGRAM_NAME
