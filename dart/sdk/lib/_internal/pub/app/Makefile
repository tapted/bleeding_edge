DPATH := /Users/tapted/devel/dart-sdk/bin

all: jszip packages app

app: js/pubchrome.dart.js

js/%.dart.js: ../lib/src/app/%.dart always
	export PATH=$(DPATH):$$PATH; dart2js --suppress-hints \
		--package-root=../lib/src/packages -o $@ $<

jszip: always
	cp -r ../js/jszip js/

packages: always
	export PATH=$(DPATH):$$PATH; (cd ../lib/src/ && pub get)

.PHONY: always
