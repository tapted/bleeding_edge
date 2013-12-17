all:
	$(MAKE) -C app

app:
	$(MAKE) -C app app

.PHONY: app all

analyze :
	dartanalyzer --package-root app/packages  lib/src/app/pubchrome.dart
