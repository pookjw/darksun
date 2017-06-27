#!/bin/sh

GM_OTA="https://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
DB_OTA="https://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/iOS11DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
PB_OTA="http://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/iOS11PublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
TOOL_VERSION=9

function showHelpMessage(){
	echo "darksun: get whole iOS system (Version : $TOOL_VERSION)"
	echo "Usage: ./darksun.sh [options...]"
	echo "Options:"
	echo "-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)"
	echo "-v	iOS version"
	echo "-p	get Public Beta Firmware (default : Public Release (GM), Developer Beta)"
	echo "example) ./darksun.sh -n N102AP -v 11.0"
	exit 1
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
		exit 1
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
	if [[ "$DOWNLOAD_PUBLIC_BETA" == YES ]]; then
		echo "Searching... (Public Beta)"
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
			parseStage1
			if [[ ! -z "$DOWNLOAD_URL" ]]; then
				break
			fi
		done
	else
		echo "Searching..."
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
			parseStage1
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

function parseStage1(){
	COUNT=0
	for VALUE in $(parseStage2); do
		if [[ "$VERBOSE" == YES ]]; then
			echo "$VALUE"
		fi
		if [[ "$COUNT" == 4 ]]; then
			if [[ "$VERBOSE" == YES ]]; then
				echo "Great."
			fi
			SECONT_URL="$(echo $VALUE | cut -d">" -f2 | cut -d"<" -f1)"
		fi
		if [[ "$COUNT" == 3 ]]; then
			FIRST_URL="$(echo $VALUE | cut -d">" -f2 | cut -d"<" -f1)"
			if [[ "$VERBOSE" == YES ]]; then
				echo "4"
			fi
			COUNT=4
			DO_NOT_RESET=YES
		fi
		if [[ "$VALUE" == "<string>$MODEL</string>" && "$COUNT" == 2 ]]; then
			if [[ "$VERBOSE" == YES ]]; then
				echo "3"
			fi
			COUNT=3
		else
			if [[ ! "$DO_NOT_RESET" == YES ]]; then
				COUNT=0
				BUILD_NAME=
				DO_NOT_RESET=
			fi
		fi
		if [[ "$COUNT" == 1 ]]; then
			BUILD_NAME="$(echo $VALUE | cut -d">" -f2 | cut -d"<" -f1)"
			if [[ "$VERBOSE" == YES ]]; then
				echo "2"
			fi
			COUNT=2
			DO_NOT_RESET=
		fi
		if [[ "$VALUE" == "<string>9.9.$VERSION</string>" && "$COUNT" == 0 ]]; then
			if [[ "$VERBOSE" == YES ]]; then
				echo "1"
			fi
			COUNT=1
			DO_NOT_RESET=YES
		fi
		if [[ ! -z "$FIRST_URL" && ! -z "$SECONT_URL" ]]; then
			DOWNLOAD_URL="$FIRST_URL$SECONT_URL"
			break
		fi
	done
}

function parseStage2(){
	cat "$PROJECT_DIR/catalog.xml" | grep "			<string>9.9.$VERSION</string>
			<string>iOS1
				<string>$MODEL</string>
			<string>http://appldnld.apple.com/
\.zip</string>"
}

function showSummary(){
	showLines "*"
	echo "Summary"
	showLines "-"
	echo "Device name : $MODEL"
	echo "iOS version : $VERSION ($BUILD_NAME)"
	echo "Update URL : $DOWNLOAD_URL"
	echo "Output : $OUTPUT_DIRECTORY"
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
	rm -rf "$PROJECT_DIR"
	exit "$1"
}

#######################################

setDestination "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
setProjectPath
searchDownloadURL
showSummary
if [[ ! "$searchOnly" == YES ]]; then
	buildBinary
	downloadUpdate
	extractUpdate
fi

