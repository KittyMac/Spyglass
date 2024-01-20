# Originally forked from https://github.com/rodonisi/libtesseract

SWIFT_BUILD_FLAGS=--configuration release

release:
	# Installing dependencies
	brew install wget automake pkg-config go-task/tap/go-task
	
	# Building
	task build-tesseract-xcframework-zip
	
clean:
	task clean-build-folder clean-artifacts clean-sources