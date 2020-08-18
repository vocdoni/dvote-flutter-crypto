.DEFAULT_GOAL := help
PROJECTNAME=$(shell basename "$(PWD)")

SHELL := /bin/bash

# ##############################################################################
# # GENERAL
# ##############################################################################

.PHONY: help
help: makefile
	@echo
	@echo " Available actions in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## init: Install missing dependencies.
.PHONY: init
init:
	flutter pub get
	git submodule init
	git submodule update
	make rust-targets
	make dev-links

## rust-targets: Compile the rust native libraries
rust-targets:
	cd rust && make init && make all

## :

# ##############################################################################
# # RECIPES
# ##############################################################################

## all: Copy iOS, Android and bindings to the artifacts folder and update the project links
all: ios android
	make release-links

## ios: Copy the iOS static library and bindings header file
ios: artifacts/libdvote.a artifacts/bindings.h

## android: Copy the shared libraries for Android
android: artifacts/arm64-v8a/libdvote.so artifacts/armeabi-v7a/libdvote.so artifacts/x86/libdvote.so

artifacts/libdvote.a: rust/target/universal/release/libdvote.a
	@mkdir -p artifacts
	@if [ $$(uname) == "Darwin" ] ; then rm -f $@ && cp $< $@ ; \
	else echo "Warning: Skipping iOS on $$(uname)" ; \
	fi

artifacts/bindings.h: rust/target/bindings.h
	@mkdir -p artifacts
	@if [ $$(uname) == "Darwin" ] ; then rm -f $@ && cp $< $@ ; \
	else echo "Warning: Skipping iOS on $$(uname)" ; \
	fi

artifacts/arm64-v8a/libdvote.so: rust/target/aarch64-linux-android/release/libdvote.so
	@mkdir -p artifacts/arm64-v8a
	rm -f $@ && cp $< $@

artifacts/armeabi-v7a/libdvote.so: rust/target/armv7-linux-androideabi/release/libdvote.so
	@mkdir -p artifacts/armeabi-v7a
	rm -f $@ && cp $< $@

artifacts/x86/libdvote.so: rust/target/i686-linux-android/release/libdvote.so
	@mkdir -p artifacts/x86
	rm -f $@ && cp $< $@

rust/target/universal/release/libdvote.a: rust-targets
rust/target/bindings.h: rust-targets
rust/target/aarch64-linux-android/release/libdvote.so: rust-targets
rust/target/armv7-linux-androideabi/release/libdvote.so: rust-targets
rust/target/i686-linux-android/release/libdvote.so: rust-targets

## :
## release-links: Make symbolic links pointing to artifacts/ (for pub.dev release)
.PHONY: release-links
release-links:
	@if [ $$(uname) == "Darwin" ] ; then \
		rm -f ios/libdvote.a && cd ios && ln -s ../artifacts/libdvote.a . ; \
	else echo "Warning: Skipping iOS on $$(uname)" ; \
	fi
	rm -f android/src/main/jniLibs/arm64-v8a/libdvote.so
	cd android/src/main/jniLibs/arm64-v8a && ln -s ../../../../../artifacts/arm64-v8a/libdvote.so .
	rm -f android/src/main/jniLibs/armeabi-v7a/libdvote.so
	cd android/src/main/jniLibs/armeabi-v7a && ln -s ../../../../../artifacts/armeabi-v7a/libdvote.so .
	rm -f android/src/main/jniLibs/x86/libdvote.so
	cd android/src/main/jniLibs/x86 && ln -s ../../../../../artifacts/x86/libdvote.so .

## dev-links: Make symbolic links pointing to rust/target/
.PHONY: dev-links
dev-links:
	@if [ $$(uname) == "Darwin" ] ; then \
		rm -f ios/libdvote.a && cd ios && ln -s ../rust/target/universal/release/libdvote.a . ; \
	else echo "Warning: Skipping iOS on $$(uname)" ; \
	fi
	rm -f android/src/main/jniLibs/arm64-v8a/libdvote.so
	cd android/src/main/jniLibs/arm64-v8a && ln -s ../../../../../rust/target/aarch64-linux-android/release/libdvote.so .
	rm -f android/src/main/jniLibs/armeabi-v7a/libdvote.so
	cd android/src/main/jniLibs/armeabi-v7a && ln -s ../../../../../rust/target/armv7-linux-androideabi/release/libdvote.so .
	rm -f android/src/main/jniLibs/x86/libdvote.so
	cd android/src/main/jniLibs/x86 && ln -s ../../../../../rust/target/i686-linux-android/release/libdvote.so .

## :

# ##############################################################################
# # OTHER
# ##############################################################################

## publish: Build, link and upload the current package to pub.dev/packages/dvote
.PHONY: publish
publish: all
	# Customize the Git ignore file so that binary artifacts are not skipped by Flutter
	@rm -f .gitignore_bak
	@cp .gitignore .gitignore_bak
	@echo -e ".DS_Store\n.dart_tool/\n.packages\n.pub/" > .gitignore
	flutter pub pub publish
	@rm .gitignore
	@mv .gitignore_bak .gitignore
	@make dev-links


## clean:
.PHONY: clean
clean: clean-example
	flutter clean
	cd rust && make clean

.PHONY: clean-example
clean-example:
	flutter clean
	rm -Rf ios/Pods
	rm -Rf ios/.symlinks
	rm -Rf ios/Flutter/Flutter.framework
	rm -Rf ios/Flutter/Flutter.podspec
