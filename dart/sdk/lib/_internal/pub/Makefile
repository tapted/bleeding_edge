all:
	$(MAKE) -C app

app:
	$(MAKE) -C app app

analyze :
	dartanalyzer --package-root app/packages  lib/src/app/pubchrome.dart

zip :
	rm -rf zip
	mkdir -p zip/js/jszip
	cp -r app/pub.html app/manifest.json app/style.css \
			app/build app/images zip/
	cp app/js/archive.js app/js/main.js zip/js
	cp app/js/jszip/jszip.js app/js/jszip/jszip-load.js \
			app/js/jszip/jszip-inflate.js zip/js/jszip
	zip -r $(shell basename $(CURDIR)).zip zip/

.PHONY: app all analyze zip
