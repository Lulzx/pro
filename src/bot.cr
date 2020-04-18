require "readability"
require "http/client"
require "tourmaline"
require "telegraph"
require "json"

class KeyError < Exception; end

class EchoBot < Tourmaline::Client
  @[On(:message)]
  def on_message(client, update)
    if message = update.message
      text = update.message.not_nil!.text.not_nil!
      response = HTTP::Client.get text
      # options = Readability::Options.new(
      #   tags: %w[article p document a aside b blockquote br code em h1 h2 h3 h4 hr i li ol p pre s strong u ul],
      #   remove_empty_nodes: true,
      #   attributes: %w[href src],
      #   blacklist: %w[figcaption figure div]
      # )
      document = Readability::Document.new(response.body)
      text = document.content
      text = text.not_nil!
      message.reply(text)
      access_token = "3330dae43d9a721f632d23a7bb241adc23630a582c3e93c9d6d9d6b6a283"
      content = ["#{text}"]
      response = Telegraph.create_page(access_token, title = "lulzx", author_name = "lulzx", author_url = "https://t.me/lulzx", %|content|, false)
      x = JSON.parse(response)
      status = x["ok"]
      begin
        if (status == true)
          text = x["result"]["url"]
        else
          text = x["error"]
        end
      rescue exception : KeyError
        puts "#{exception}"
      end
      message.reply(text)
    end
  end
end

API_KEY = "766781853:AAFBvXugAvG4OMcNssIN9rQAANRqcd3Z1E8"
bot = EchoBot.new(API_KEY)
bot.poll
