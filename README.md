![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole iOS/watchOS system

Only works with signed OTA version like 8.4.1, 9.3.5, etc... Compatible with iOS 8 or later including beta.

Tested on macOS, iOS. (Running on iOS requires jailbreak, and may have to use `--no-ssl` option)

darksun uses [emonti/ota2tar](https://github.com/emonti/ota2tar) so requires libarchive to run.

## Usage

	./darksun.sh [options...]
	Options:
	-n		internal device name (see https://www.theiphonewiki.com/wiki/Models)
	-v		iOS/watchOS version
	-p		get iOS Public Beta Firmware (default: all)
	-s		search only
	--verbose	run verbose mode
	--no-ssl	no SSL mode
	example) ./darksun.sh -n N102AP -v 11.0
