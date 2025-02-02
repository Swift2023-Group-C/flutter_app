.PHONY: install build run clean

install:
	fvm flutter pub get

build: install
	fvm flutter pub run build_runner build --delete-conflicting-outputs

run: build
	fvm flutter run

clean:
	fvm flutter clean
