require "readability"
require "http/client"
require "tourmaline"
require "telegraph"
require "json"
require "myhtml"

class KeyError < Exception; end

def walk(node, level = 0)
  puts "#{" " * level * 2}#{node.inspect}"
  node.children.each { |child| walk(child, level + 1) }
end


class EchoBot < Tourmaline::Client
  @[On(:message)]
  def on_message(client, update)
    if message = update.message
      text = update.message.not_nil!.text.not_nil!
      response = HTTP::Client.get text
      options = Readability::Options.new(
        tags: %w[article p document a aside b blockquote br code em h1 h2 h3 h4 hr i li ol p pre s strong u ul],
        remove_empty_nodes: true,
        attributes: %w[href src],
        blacklist: %w[figcaption figure]
      )
      document = Readability::Document.new(response.body, options)
      text = document.content
      text = text.not_nil!
      html = <<-HTML
      #{text}
      HTML
      
      myhtml = Myhtml::Parser.new(html)

      text = myhtml.to_pretty_html
      parser = Myhtml::Parser.new(str, tree_options: Myhtml::Lib::MyhtmlTreeParseFlags::MyHTML_TREE_PARSE_FLAGS_SKIP_WHITESPACE_TOKEN)
      puts walk(parser.root!)
      message.reply(text)
    end
  end
end

API_KEY = "766781853:AAFBvXugAvG4OMcNssIN9rQAANRqcd3Z1E8"
bot = EchoBot.new(API_KEY)
bot.poll
