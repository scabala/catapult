# -*- coding: utf-8-unix -*-

DESTDIR   =
PREFIX    = /usr/local
DATADIR   = $(DESTDIR)$(PREFIX)/share
LOCALEDIR = $(DESTDIR)$(PREFIX)/share/locale

check:
	flake8 .
	flake8 bin/*

clean:
	rm -rf build
	rm -rf catapult.egg-info
	rm -rf dist
	rm -rf __pycache__
	rm -rf */__pycache__
	rm -rf */*/__pycache__
	rm -rf */*/*/__pycache__

install:
	@echo "INSTALLING PYTHON PACKAGE..."
	./setup-partial.py install $(if $(DESTDIR),--root=$(DESTDIR),) --prefix=$(PREFIX)
	@echo "INSTALLING DATA FILES..."
	mkdir -p $(DATADIR)/catapult/themes
	cp -f data/themes/*.css $(DATADIR)/catapult/themes
	@echo "INSTALLING ICONS..."
	mkdir -p $(DATADIR)/icons/hicolor/scalable/apps
	mkdir -p $(DATADIR)/icons/hicolor/symbolic/apps
	cp -f data/icons/io.otsaloma.catapult.svg $(DATADIR)/icons/hicolor/scalable/apps
	cp -f data/icons/io.otsaloma.catapult-symbolic.svg $(DATADIR)/icons/hicolor/symbolic/apps
	@echo "INSTALLING TRANSLATIONS..."
	for LANG in `cat po/LINGUAS`; do \
	echo $$LANG; \
	mkdir -p $(LOCALEDIR)/$$LANG/LC_MESSAGES; \
	msgfmt po/$$LANG.po -o $(LOCALEDIR)/$$LANG/LC_MESSAGES/catapult.mo; \
	done
	@echo "INSTALLING DESKTOP FILE..."
	mkdir -p $(DATADIR)/applications
	msgfmt --desktop -d po \
	--template data/io.otsaloma.catapult.desktop.in \
	-o $(DATADIR)/applications/io.otsaloma.catapult.desktop
	@echo "INSTALLING APPDATA FILE..."
	mkdir -p $(DATADIR)/metainfo
	msgfmt --xml -d po \
	--template data/io.otsaloma.catapult.appdata.xml.in \
	-o $(DATADIR)/metainfo/io.otsaloma.catapult.appdata.xml

test:
	py.test -xs .

.PHONY: check clean install test
