MONGODB_URL='mongodb://localhost:27017/mongoose-fixtures?safe=true'
JASMINE_PATH='./node_modules/.bin/jasmine-node'
COFFEELINT_PATH='./node_modules/.bin/coffeelint'

build:
	./node_modules/.bin/coffee \
		--compile \
		--bare \
		--output ./lib \
		./src

coffeelint:
	$(COFFEELINT_PATH) -f coffeelint.config.json ./src/*.coffee ./tests/*.coffee

test:
	MONGODB_URL=$(MONGODB_URL) \
	$(JASMINE_PATH) \
		--forceexit \
		--verbose \
		./tests

.PHONY: build coffeelint test
