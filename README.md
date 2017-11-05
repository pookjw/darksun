![Image](https://farm5.staticflickr.com/4212/35116006470_677981dc18_b.jpg)

# darksun

get whole file system

Tested on macOS. Happy reversing. :)

## Compatiblity

Only works with signed OTA version like iOS 6.1.3, 7.1.2, 8.4.1, 9.3.5, 10.3.3, etc...

- iOS 6 or later

- watchOS 3 or later

- tvOS 10 or later

- HomePod

exception: iPhone3,1 OSVersion=7.1.2 PrerequisiteBuild=11D201 (7.1.1) is not supported.

## Usage

	Usage: ./darksun.sh [options...]
	Options:
	-n [name]		device identifier (see https://www.theiphonewiki.com/wiki/Models)
	-v [version]		system version
	-e [prerequisite]	get Short update file (default: Full)
	-d			get Developer Beta Firmware (default: GM only)
	-p			get Public Beta Firmware (default: GM only)
	-m [mobileconfig]	get Firmware from OTA Profile(.mobileconfig) (default: GM only)
	-c [url]		get Firmware from custom assets URL
	-i			run interface mode
	-s			search only
	-u			only show update URL on summary
	--loop			search ota infinitely until update found
	--verbose		run verbose mode
	--no-ssl		no SSL mode
	--do-not-clean		do not clean temp dir on quit

## Example

▼ get iPod7,1_10.3.3 file system

	$ ./darksun.sh -n iPod7,1 -v 10.3.3

▼ get patch/new file when updating 14E304 to 10.3.3 (`-v` only supports version, `-e` only supports build number)

	$ ./darksun.sh -n iPod7,1 -v 10.3.3 -e 14E304

▼ get iPod7,1_11.2 Developer Beta file system

	$ ./darksun.sh -n iPod7,1 -v 11.2 -d

▼ get iPod7,1_11.2 Public Beta file system

	$ ./darksun.sh -n iPod7,1 -v 11.2 -p

▼ get iPod7,1_11.2 file system from OTA Profile (.mobileconfig)

	$ ./darksun.sh -n iPod7,1 -v 11.2 -m [mobileconfig]

▼ get iPod7,1_11.2 file system from assets url ([See assets url list](https://www.theiphonewiki.com/wiki/OTA_Updates#OTA_updates_list))

	$ ./darksun.sh -n iPod7,1 -v 11.2 -c [url]

▼ search only
	
	$ ./darksun.sh -n iPod7,1 -v 10.3.3 -s
	Searching... (will take a long time)
	***********************************************
	SUMMARY (darksun-XX)
	-----------------------------------------------
	Device name: iPod7,1
	Version: 10.3.3
	Build: 14G60
	Internal build name: iOS1033GM
	Public build name: iOS 10.3.3
	Update type: Full
	Update URL: http://appldnld.apple.com/ios10.3.3/091-23228-20170719-B311CB1A-697B-11E7-9148-5E9500BA0AE3/com_apple_MobileAsset_SoftwareUpdate/b9fa0dc04dcefea4845c9ceeb2e7e80efc9e9ee6.zip
	Documentation URL: http://appldnld.apple.com/ios10.3.3/091-19447-20170717-3D5EFFA4-5D15-11E7-9164-A3FB7F942F55/com_apple_MobileAsset_SoftwareUpdateDocumentation/be4682f7d73df18e439955e0f128a3b5b81dbe14.zip
	***********************************************

▼ search only & get OTA URL only

	$ ./darksun.sh -n iPod7,1 -v 10.3.3 -s -u
	http://appldnld.apple.com/ios10.3.3/091-23228-20170719-B311CB1A-697B-11E7-9148-5E9500BA0AE3/com_apple_MobileAsset_SoftwareUpdate/b9fa0dc04dcefea4845c9ceeb2e7e80efc9e9ee6.zip

## References

[OTA Updates](https://www.theiphonewiki.com/wiki/OTA_Updates)

[Recreating the iOS filesystem from an OTA](http://newosxbook.com/articles/OTA3.html)
