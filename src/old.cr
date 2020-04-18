require "tourmaline"

class EchoBot < Tourmaline::Client
  @[On(:message)]
  def on_message(client, update)
    if message = update.message
      text = update.message.not_nil!.text.not_nil!
      message.reply(text)
    end
  end
end

API_KEY = "766781853:AAFMOMJb-yZTOGmmNiNHwLrqvreXmnl7deo"
bot = EchoBot.new(API_KEY)
bot.poll
