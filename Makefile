DOCKER_TAG = bazel
SOURCEDIR = ${PWD}/src

run:
	docker run -it --rm \
	-u $$(id -u):$$(id -g) \
	-v $(SOURCEDIR):/src \
	-w /src \
	$(DOCKER_TAG) 

build:
	docker build -t $(DOCKER_TAG) .

