require "tourmaline"
require "http/request"
require "file"
require "dotenv"


# The default file is ".env"
Dotenv.load #".env-file"

module PimspiratieBot
  VERSION = "0.1.0"
end

module Tourmaline
    module Handlers

      annotation OnPhoto; end

      class PhotoHandler < Tourmaline::EventHandler
        # This is needed for the macro which registers the handler
        # to know which annotation belongs to it.
        ANNOTATION = OnPhoto

        # All handlers need at least these 3 things in their initialize method
        def initialize(group = :default, priority = 0, &block : Context ->)
          super(group, priority)
          @proc = block
        end

        # All handlers also need a `call` method. This gets called on every Update,
        # unless another handler with the same group gets called first.
        def call(client : Client, update : Update)
          if message = update.message
            return unless message.photo.size > 0

            ctx = Context.new(update, message, message.photo)
            @proc.call(ctx)

            # returning true lets other handlers in the same group know not to respond
            true
          end
        end

        # Handlers with an annotation also need a Context object. This can be a class, struct,
        # or an alias to another type. All that matters is that it exists.
        record Context, update : Update, message : Message, photos : Array(PhotoSize)
    end
  end
end

class EchoBot < Tourmaline::Client

  def filename_basename(ctx)
    date = ctx.message.date.to_s.split(" ")[0]
    "messages/" + ctx.message.message_id.to_s + "_" + date + "_"
  end

  @[Command("echo")]
  def echo_command(ctx)
    ctx.message.reply(ctx.text)
  end

  @[Hears(/http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+/)]
  def on_link(ctx)
    File.write(filename_basename(ctx) + "link.txt", ctx.text)
    pp "wrote new link: " + ctx.text
  end

  @[OnPhoto]
  def on_photo(ctx)
    photo = ctx.photos.last

    if link = get_file_link(photo.file_id)
      HTTP::Client.get(link) do |response|
       File.write(filename_basename(ctx) + "_image.jpg", response.body_io)
      end
    end
  end
end

bot = EchoBot.new(bot_token: ENV["API_KEY"])
bot.poll

