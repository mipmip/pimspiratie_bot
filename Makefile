all: test build

build:
				crystal build src/pimspiratie_bot.cr

test:
				KEMAL_ENV=test crystal spec
clean:
				rm -f ./pimspiratie_bot
