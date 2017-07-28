![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole iOS/watchOS system

Only works with signed OTA version like 8.4.1, 9.3.5, 10.3.3 etc... Compatible with iOS 8/watchOS 3 or later.

Tested on macOS, iOS. (Running on iOS requires jailbreak and dependencies. may have to use `--no-ssl` option)

darksun uses [emonti/ota2tar](https://github.com/emonti/ota2tar) so requires libarchive to run.

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
	example) ./darksun.sh -n iPod7,1 -v 10.3.3
