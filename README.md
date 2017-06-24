# darksun

get whole iOS system easily

Only works with latest iOS version including beta. Not for old iOS.

darksun uses [emonti/ota2tar](https://github.com/emonti/ota2tar) so requires libarchive to run.

## Usage

	./darksun.sh [options...]
	Options:
	-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)
	-v	iOS version
	example) ./darksun.sh -n N102AP -v 11.0
