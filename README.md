![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole file system

Tested on macOS, iOS. (Running on iOS requires jailbreak and dependencies. may have to use `--no-ssl` option)

## Compatiblity

**Only works with signed OTA version like iOS 8.4.1, 9.3.5, 10.3.3 etc...**

- iOS 8 or later

- watchOS 3 or later

- tvOS 10 or later

- HomePod

## Usage

	Usage: ./darksun.sh [options...]
	Options:
	-n [name]		device identifier (see https://www.theiphonewiki.com/wiki/Models)
	-v [version]		iOS/watchOS version
	-e [prerequisite]	get delta update file (default: combo)
	-d			get Developer Beta Firmware (default: GM only)
	-p			get Public Beta Firmware (default: GM only)
	-s			search only
	-u			only show update URL on summary
	--verbose		run verbose mode
	--no-ssl		no SSL mode
	--example		show command example

## References

[OTA Updates](https://www.theiphonewiki.com/wiki/OTA_Updates)

[Recreating the iOS filesystem from an OTA](http://newosxbook.com/articles/OTA3.html)
