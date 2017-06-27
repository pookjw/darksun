![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole iOS system

Only works with signed OTA version like 8.4.1, 9.3.5, etc... Compatible with iOS 8 or later including beta.

Tested on macOS.

darksun uses [emonti/ota2tar](https://github.com/emonti/ota2tar) so requires libarchive to run.

## Usage

	./darksun.sh [options...]
	Options:
	-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)
	-v	iOS version
	-p	get Public Beta Firmware (default : Public Release (GM), Developer Beta)
	example) ./darksun.sh -n N102AP -v 11.0
