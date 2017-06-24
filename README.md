![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole iOS system easily

Only works with latest iOS version including beta. Not for old iOS.

Tested on macOS.

darksun uses [emonti/ota2tar](https://github.com/emonti/ota2tar) so requires libarchive to run.

## Usage

	./darksun.sh [options...]
	Options:
	-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)
	-v	iOS version
	example) ./darksun.sh -n N102AP -v 11.0
