require "tourmaline"
require "dotenv"


# The default file is ".env"
Dotenv.load #".env-file"

module PimspiratieBot
  VERSION = "0.1.0"
end

class EchoBot < Tourmaline::Client
  @[Command("echo")]
  def echo_command(ctx)
    ctx.message.reply(ctx.text)
  end

  @[Hears(/http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+/)]
  def on_link(ctx)
    ctx.message.reply(ctx.text)
  end
end

bot = EchoBot.new(bot_token: ENV["API_KEY"])
bot.poll

