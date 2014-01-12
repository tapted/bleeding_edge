DPATH := /Users/tapted/devel/dart-sdk/bin

all: jszip packages app

app: build/app build/app/pubchrome.dart.js

build/%.dart.js: ../lib/src/%.dart always
	export PATH=$(DPATH):$$PATH; dart2js --suppress-hints --package-root=packages -o $@ $<

jszip: always
	cp -r ../js/jszip js/

packages: always
	export PATH=$(DPATH):$$PATH; pub get
	tar hc packages | (cd ../lib/src/app && tar x)
	mv packages/browser packages/browser_symlink
	mkdir packages/browser
	(cd packages/browser_symlink && tar c .) | (cd packages/browser && tar x)

build/app:
	mkdir -p build/app

.PHONY: always
