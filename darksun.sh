#!/bin/sh

GM_OTA="https://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
# DB OTA
# 1. 
DB_OTA="https://mesu.apple.com/assets/iOS11DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/seed-R40.Subdivide/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/seed-R40.2112/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
PB_OTA="https://mesu.apple.com/assets/iOS11PublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
TOOL_VERSION=12

function showHelpMessage(){
	echo "darksun: get whole iOS system (Version : $TOOL_VERSION)"
	echo "Usage: ./darksun.sh [options...]"
	echo "Options:"
	echo "-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)"
	echo "-v	iOS version"
	echo "-p	get Public Beta Firmware (default : Public Release (GM), Developer Beta)"
	echo "example) ./darksun.sh -n N102AP -v 11.0"
	quitTool 1
}

function setDestination(){
	if [[ "$1" == -n ]]; then
		MODEL="$2"
	fi
	if [[ "$2" == -n ]]; then
		MODEL="$3"
	fi
	if [[ "$3" == -n ]]; then
		MODEL="$4"
	fi
	if [[ "$4" == -n ]]; then
		MODEL="$5"
	fi
	if [[ "$5" == -n ]]; then
		MODEL="$6"
	fi
	if [[ "$6" == -n ]]; then
		MODEL="$7"
	fi
	if [[ "$7" == -n ]]; then
		MODEL="$8"
	fi
	if [[ "$8" == -n ]]; then
		MODEL="$9"
	fi

	if [[ "$1" == -v ]]; then
		VERSION="$2"
	fi
	if [[ "$2" == -v ]]; then
		VERSION="$3"
	fi
	if [[ "$3" == -v ]]; then
		VERSION="$4"
	fi
	if [[ "$4" == -v ]]; then
		VERSION="$5"
	fi
	if [[ "$5" == -v ]]; then
		VERSION="$6"
	fi
	if [[ "$6" == -v ]]; then
		VERSION="$7"
	fi
	if [[ "$7" == -v ]]; then
		VERSION="$8"
	fi
	if [[ "$8" == -v ]]; then
		VERSION="$9"
	fi

	if [[ "$1" == "-p" || "$2" == "-p" || "$3" == "-p" || "$4" == "-p" || "$5" == "-p" || "$6" == "-p" || "$7" == "-p" || "$8" == "-p" || "$9" == "-p" ]]; then
		DOWNLOAD_PUBLIC_BETA=YES
	fi
	if [[ "$1" == "-verbose" || "$2" == "-verbose" || "$3" == "-verbose" || "$4" == "-verbose" || "$5" == "-verbose" || "$6" == "-verbose" || "$7" == "-verbose" || "$8" == "-verbose" || "$9" == "-verbose" ]]; then
		VERBOSE=YES
	fi
	if [[ "$1" == "-searchOnly" || "$2" == "-searchOnly" || "$3" == "-searchOnly" || "$4" == "-searchOnly" || "$5" == "-searchOnly" || "$6" == "-searchOnly" || "$7" == "-searchOnly" || "$8" == "-searchOnly" || "$9" == "-searchOnly" ]]; then
		searchOnly=YES
	fi
	if [[ -z "$MODEL" || -z "$VERSION" ]]; then
		showHelpMessage
	fi
	OUTPUT_DIRECTORY="$(pwd)"
	if [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
		echo "$OUTPUT_DIRECTORY: : No such file or directory"
		quitTool 1
	fi
}

function setProjectPath(){
	COUNT=0
	while(true); do
		if [[ -d "/tmp/darksun/$COUNT" ]]; then
			COUNT=$((COUNT+1))
		else
			mkdir -p "/tmp/darksun/$COUNT"
			PROJECT_DIR="/tmp/darksun/$COUNT"
			if [[ "$VERBOSE" == YES ]]; then
				echo "Temp folder : $PROJECT_DIR"
			fi
			break
		fi
	done
}

function searchDownloadURL(){
	echo "Searching... (will take a long time)"
	if [[ "$DOWNLOAD_PUBLIC_BETA" == YES ]]; then
		for URL in $PB_OTA; do
			if [[ -f "$PROJECT_DIR/catalog.xml" ]]; then
				rm "$PROJECT_DIR/catalog.xml"
			fi
			if [[ "$VERBOSE" == YES ]]; then
				echo "Downloading $URL"
				curl -o "$PROJECT_DIR/catalog.xml" "$URL"
			else
				curl -s -o "$PROJECT_DIR/catalog.xml" "$URL"
			fi
			if [[ ! -f "$PROJECT_DIR/catalog.xml" ]]; then
				echo "ERROR : Failed to download."
				quitTool 1
			fi
			parseAsset
			if [[ ! -z "$DOWNLOAD_URL" ]]; then
				break
			fi
		done
	else
		for URL in $GM_OTA $DB_OTA; do
			if [[ -f "$PROJECT_DIR/catalog.xml" ]]; then
				rm "$PROJECT_DIR/catalog.xml"
			fi
			if [[ "$VERBOSE" == YES ]]; then
				echo "Downloading $URL"
				curl -o "$PROJECT_DIR/catalog.xml" "$URL"
			else
				curl -s -o "$PROJECT_DIR/catalog.xml" "$URL"
			fi
			if [[ ! -f "$PROJECT_DIR/catalog.xml" ]]; then
				echo "ERROR : Failed to download."
				quitTool 1
			fi
			parseAsset
			if [[ ! -z "$DOWNLOAD_URL" ]]; then
				break
			fi
		done
	fi
	if [[ -z "$DOWNLOAD_URL" ]]; then
		echo "$MODEL | $VERSION not found."
		quitTool 1
	fi
}

function parseAsset(){
	VALUE=
	BUILD_NAME=
	COUNT=0
	PASS_ONCE_0=NO
	PASS_ONCE_1=NO
	PASS_ONCE_2=NO
	PASS_ONCE_3=NO
	PASS_ONCE_4=NO
	PASS_ONCE_5=NO
	PASS_ONCE_6=NO
	PASS_ONCE_7=NO
	PASS_ONCE_8=NO
	FIRST_URL=
	SECONT_URL=
	DOWNLOAD_URL=
	for VALUE in $(cat "$PROJECT_DIR/catalog.xml"); do
		if [[ "$PASS_ONCE_8" == YES && "$COUNT" == 3 ]]; then
			SECONT_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			PASS_ONCE_8=NO
			DOWNLOAD_URL="$FIRST_URL$SECONT_URL"
			break
		fi
		if [[ "$VALUE" == "<key>__RelativePath</key>" && "$COUNT" == 3 ]]; then
			PASS_ONCE_8=YES
		fi
		if [[ "$PASS_ONCE_7" == YES && "$COUNT" == 2 ]]; then
			FIRST_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			PASS_ONCE_7=NO
			COUNT=3
		fi
		if [[ "$VALUE" == "<key>__BaseURL</key>" && "$COUNT" == 2 ]]; then
			PASS_ONCE_7=YES
		fi
		if [[ "$PASS_ONCE_6" == YES && "$COUNT" == 1 ]]; then
			if [[ "$VALUE" == "<string>$MODEL</string>" ]]; then
				COUNT=2
			else
				BUILD_NAME=
				COUNT=0
			fi
			PASS_ONCE_6=NO
		fi
		if [[ "$PASS_ONCE_5" == YES && "$COUNT" == 1 ]]; then
			PASS_ONCE_5=NO
			PASS_ONCE_6=YES
		fi
		if [[ "$VALUE" == "<key>SupportedDevices</key>" && "$COUNT" == 1 ]]; then
			PASS_ONCE_5=YES
		fi
		if [[ "$PASS_ONCE_4" == YES && "$COUNT" == 1 ]]; then
			if [[ "$VALUE" == "<string>$MODEL</string>" ]]; then
				COUNT=2
			fi
			PASS_ONCE_4=NO
		fi
		if [[ "$PASS_ONCE_3" == YES && "$COUNT" == 1 ]]; then
			PASS_ONCE_3=NO
			PASS_ONCE_4=YES
		fi
		if [[ "$VALUE" == "<key>SupportedDeviceModels</key>" && "$COUNT" == 1 ]]; then
			PASS_ONCE_3=YES
		fi
		if [[ "$PASS_ONCE_2" == YES && "$COUNT" == 1 ]]; then
			BUILD_NAME="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			PASS_ONCE_2=NO
		fi
		if [[ "$VALUE" == "<key>SUDocumentationID</key>" && "$COUNT" == 1 ]]; then
			PASS_ONCE_2=YES
		fi
		if [[ "$PASS_ONCE_1" == YES && "$COUNT" == 1 ]]; then
			if [[ ! "$VALUE" == "<string>10A403</string>" && ! "$VALUE" == "<string>10A405</string>" && ! "$VALUE" == "<string>10A406</string>" && ! "$VALUE" == "<string>10A407</string>" ]]; then # for iOS 8.4.1
				COUNT=0
			fi
			PASS_ONCE_1=NO
		fi
		if [[ "$VALUE" == "<key>PrerequisiteBuild</key>" && "$COUNT" == 1 ]]; then
			PASS_ONCE_1=YES
		fi
		if [[ "$PASS_ONCE_0" == YES && "$COUNT" == 0 ]]; then
			if [[ "$VALUE" == "<string>9.9.$VERSION</string>" ]]; then # for iOS 10 or later
				COUNT=1
			elif [[ "$VALUE" == "<string>$VERSION</string>" ]]; then # for iOS 8~9
				COUNT=1
			fi
			PASS_ONCE_0=NO
		fi
		if [[ "$VALUE" == "<key>OSVersion</key>" && "$COUNT" == 0 ]]; then
			PASS_ONCE_0=YES
		fi
	done
}

function showSummary(){
	showLines "*"
	echo "Summary"
	showLines "-"
	echo "Device name : $MODEL"
	echo "iOS version : $VERSION ($BUILD_NAME)"
	echo "Update URL : $DOWNLOAD_URL"
	if [[ ! "$searchOnly" == YES ]]; then
		echo "Output : $OUTPUT_DIRECTORY"
	fi
	showLines "*"
}

function buildBinary(){
	echo "Building ota2tar... (https://github.com/emonti/ota2tar)"
	if [[ -d "$PROJECT_DIR/ota2tar" ]]; then
		rm -rf "$PROJECT_DIR/ota2tar"
	fi
	cd "$PROJECT_DIR"
	# See https://github.com/emonti/ota2tar
	git clone https://github.com/emonti/ota2tar
	cd ota2tar/src
	make ota2tar # Requires libarchive
	if [[ ! -f ota2tar ]]; then
		echo "ERROR : Can't build ota2tar"
		quitTool 1
	fi
}

function downloadUpdate(){
	if [[ -f "$PROJECT_DIR/update.zip" ]]; then
		rm "$PROJECT_DIR/update.zip"
	fi
	echo "Downloading update file..."
	if [[ "$VERBOSE" == YES ]]; then
		curl -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
	else
		curl -# -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
	fi
	if [[ ! -f "$PROJECT_DIR/update.zip" ]]; then
		echo "ERROR : Can't download update file."
		quitTool 1
	fi
}

function extractUpdate(){
	echo "Extracting... (1)"
	if [[ "$VERBOSE" == YES ]]; then
		unzip -o -j -d "$PROJECT_DIR" "$PROJECT_DIR/update.zip" "AssetData/payloadv2/payload"
	else
		unzip -qq -o -j -d "$PROJECT_DIR" "$PROJECT_DIR/update.zip" "AssetData/payloadv2/payload"
	fi
	cd "$OUTPUT_DIRECTORY"
	if [[ -f "$BUILD_NAME ($MODEL)" ]]; then
		rm "$BUILD_NAME ($MODEL)"
	fi
	if [[ -f "$BUILD_NAME ($MODEL).ota" ]]; then
		rm "$BUILD_NAME ($MODEL).ota"
	fi
	if [[ -f "$BUILD_NAME ($MODEL).tar" ]]; then
		rm "$BUILD_NAME ($MODEL).tar"
	fi
	if [[ -d "$BUILD_NAME ($MODEL)" ]]; then
		rm -rf "$BUILD_NAME ($MODEL)"
	fi
	if [[ -d "$BUILD_NAME ($MODEL).ota" ]]; then
		rm -rf "$BUILD_NAME ($MODEL).ota"
	fi
	if [[ -d "$BUILD_NAME ($MODEL).tar" ]]; then
		rm -rf "$BUILD_NAME ($MODEL).tar"
	fi
	mv "$PROJECT_DIR/payload" "$BUILD_NAME ($MODEL)"
	echo "Extracting... (2)"
	"$PROJECT_DIR/ota2tar/src/ota2tar" "$BUILD_NAME ($MODEL)"
	if [[ -f "$BUILD_NAME ($MODEL).tar" ]]; then
		rm "$BUILD_NAME ($MODEL)"
		echo "Success! Check $OUTPUT_DIRECTORY/$BUILD_NAME ($MODEL).tar"
		quitTool 0
	else
		echo "ERROR!"
		quitTool 1
	fi
}

function showLines(){
	PRINTED_COUNTS=0
	COLS=`tput cols`
	if [[ "$COLS" -ge 1 ]]; then
		while [[ ! $PRINTED_COUNTS == $COLS ]]; do
			printf "$1"
			PRINTED_COUNTS=$(($PRINTED_COUNTS+1))
		done
		echo
	fi
}

function quitTool(){
	if [[ -d "$PROJECT_DIR" && ! -z "$PROJECT_DIR" ]]; then
		rm -rf "$PROJECT_DIR"
	fi
	exit "$1"
}

#######################################

setDestination "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
setProjectPath
searchDownloadURL
showSummary
if [[ "$searchOnly" == YES ]]; then
	quitTool 0
else
	buildBinary
	downloadUpdate
	extractUpdate
fi

