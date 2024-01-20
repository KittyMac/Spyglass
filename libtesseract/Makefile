# Originally forked from https://github.com/rodonisi/libtesseract

SWIFT_BUILD_FLAGS=--configuration release
VERSION := $(shell git describe --abbrev=0)

init:
	# Installing dependencies
	brew install wget automake pkg-config go-task/tap/go-task

build: init
	# Building
	task build-tesseract-xcframework-zip

release: build
	# Updating Package.swift
	$(eval CHECKSUM := $(shell shasum -a 256 ./libtesseract.xcframework.zip | sed 's/ .*//'))
	@(cd ../ && sed -i.bak "s@checksum: \"[^\"]*@checksum: \"$(CHECKSUM)@g" Package.swift && rm Package.swift.bak)
	@(cd ../ && sed -i.bak "s@url: \"[^\"]*@url: \"https://github.com/SmallPlanet/RoveriOS/releases/download/$(VERSION)/libtesseract.xcframework.zip@g" Package.swift && rm Package.swift.bak)

	# Commit tagged release
	@(cd ../ && sed -i.bak "s@Latest version: .*@Latest version: $(VERSION)@g" README.md && rm README.md.bak)
	
	@(cd ../ && git commit -a -m "$(VERSION)" && git tag "$(VERSION)")
	@(cd ../ && git push && git push --tags)
    
	# Creating github release
	@(cd ../ && gh release create "$(VERSION)" --generate-notes /tmp/libtesseract.xcframework.zip)
	
	
clean:
	task clean-build-folder clean-artifacts clean-sources