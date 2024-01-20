# Originally forked from https://github.com/rodonisi/libtesseract

SWIFT_BUILD_FLAGS=--configuration release
VERSION := $(shell git describe --tags --abbrev=0)

init:
	# Installing dependencies
	brew install wget automake pkg-config go-task/tap/go-task

build: init
	rm -rf libtesseract.xcframework
	rm -rf libtesseract.xcframework.zip
	
	# Building
	task build-tesseract-xcframework-zip

release: build
	$(eval NEWVERSION := $(shell read -p "Enter version tag numer (ie $(VERSION)): " version; echo $$version))
	
	# Updating Package.swift
	$(eval CHECKSUM := $(shell shasum -a 256 ./libtesseract.xcframework.zip | sed 's/ .*//'))
	@(cd ../ && sed -i.bak "s@checksum: \"[^\"]*@checksum: \"$(CHECKSUM)@g" Package.swift && rm Package.swift.bak)
	@(cd ../ && sed -i.bak "s@url: \"https://github.com/KittyMac/Spyglass/releases/download[^\"]*@url: \"https://github.com/KittyMac/Spyglass/releases/download/$(NEWVERSION)/libtesseract.xcframework.zip@g" Package.swift && rm Package.swift.bak)

	# Commit tagged release
	@(cd ../ && sed -i.bak "s@Latest version: .*@Latest version: $(NEWVERSION)@g" README.md && rm README.md.bak)
	
	@(cd ../ && git commit -a -m "$(NEWVERSION)" && git tag "$(NEWVERSION)")
	@(cd ../ && git push && git push --tags)
    
	# Creating github release
	@(gh release create "$(NEWVERSION)" --generate-notes libtesseract.xcframework.zip)
	
clean:
	task clean-build-folder clean-artifacts clean-sources