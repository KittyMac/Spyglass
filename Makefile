SWIFT_BUILD_FLAGS=--configuration release

build:
	swift build -Xswiftc -enable-library-evolution -v $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build

test:
	swift test -v

update:
	swift package update

profile: clean
	mkdir -p /tmp/Spyglass.stats
	swift build \
		--configuration release \
		-Xswiftc -stats-output-dir \
		-Xswiftc /tmp/Spyglass.stats \
		-Xswiftc -trace-stats-events \
		-Xswiftc -driver-time-compilation \
		-Xswiftc -debug-time-function-bodies
		
docker-all: fedora37 fedora38

focal: docker
	docker buildx build --file Dockerfile-focal --platform linux/amd64,linux/arm64 --push -t kittymac/spyglass .

fedora37: docker
	docker buildx build --file Dockerfile-fedora37 --platform linux/amd64,linux/arm64 --push -t kittymac/spyglass .

fedora38: docker
	docker buildx build --file Dockerfile-fedora38 --platform linux/amd64,linux/arm64 --push -t kittymac/spyglass .

docker:
	-docker buildx create --name cluster_builder203
	-DOCKER_HOST=ssh://rjbowli@192.168.111.203 docker buildx create --name cluster_builder203 --platform linux/amd64 --append
	-docker buildx use cluster_builder203
	-docker buildx inspect --bootstrap
	-docker login
	swift package resolve

# docker run --rm -it --entrypoint bash swift:5.7.1-focal-slim
