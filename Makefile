NAME = graphite-clickhouse
VERSION = 0.4.2
RELEASE = 1
GIT_REPO = https://github.com/lomik/graphite-clickhouse
PKG_HOME_ROOT = /opt

build-bin:
	if [ ! -d "build" ]; then \
		git clone $(GIT_REPO) build; \
	fi
	cd build ; \
	git co tags/v$(VERSION); \
	make submodules && make

build-deb:
	rm -rf $(NAME)-$(VERSION)
	cp -a deb-root $(NAME)-$(VERSION)
	sed -e "s#%VERSION%#$(VERSION)#" \
	        -e "s#%NAME%#$(NAME)#" \
	        -e "s#%RELEASE%#$(RELEASE)#" deb-root/DEBIAN/control.in > $(NAME)-$(VERSION)/DEBIAN/control

	mkdir -p $(NAME)-$(VERSION)/$(PKG_HOME_ROOT)/$(NAME)
	if [ ! -e "build/$(NAME)"  ]; then \
		echo "Error: build/$(NAME) not found. run 'make build' first"; \
		exit 1; \
	fi
	cp build/$(NAME) $(NAME)-$(VERSION)/$(PKG_HOME_ROOT)/$(NAME)
	fakeroot dpkg-deb --build $(NAME)-$(VERSION) && mv $(NAME)-$(VERSION).deb $(NAME)_$(VERSION)-$(RELEASE)_all.deb

all: build-bin build-deb

clean-build:
	@rm -rf build

clean-deb:
	@rm -rf $(NAME)-$(VERSION) *.deb

clean: clean-deb clean-build


