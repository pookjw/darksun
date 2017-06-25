#!/bin/sh

OTA="http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/iOS11DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
TOOL_VERSION=8
VERBOSE=NO

function showHelpMessage(){
	echo "darksun: get whole iOS system (Version : $TOOL_VERSION)"
	echo "Usage: ./darksun.sh [options...]"
	echo "Options:"
	echo "-n	internal device name (See https://www.theiphonewiki.com/wiki/Models)"
	echo "-v	iOS version"
	echo "example) ./darksun.sh -n N102AP -v 11.0"
	exit 1
}

function setDestination(){
	if [[ "$1" == -n ]]; then
		MODEL="$2"
	fi
	if [[ "$3" == -n ]]; then
		MODEL="$4"
	fi

	if [[ "$1" == -v ]]; then
		VERSION="$2"
	fi
	if [[ "$3" == -v ]]; then
		VERSION="$4"
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
	echo "Searching..."
	for URL in $OTA; do
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
		if [[ "$COUNT" == 3 ]]; then
			SECONT_URL="$(echo $VALUE | cut -d">" -f2 | cut -d"<" -f1)"
		fi
		if [[ "$COUNT" == 2 ]]; then
			FIRST_URL="$(echo $VALUE | cut -d">" -f2 | cut -d"<" -f1)"
			COUNT=3
			FINAL_LOOP=YES
		fi
		if [[ "$VALUE" == "<string>$MODEL</string>" && "$COUNT" == 1 ]]; then
			COUNT=2
		else
			if [[ ! "$FINAL_LOOP" == YES ]]; then
				COUNT=0
			fi
		fi
		if [[ "$VALUE" == "<string>9.9.$VERSION</string>" && "$COUNT" == 0 ]]; then
			COUNT=1
		fi
		if [[ ! -z "$FIRST_URL" && ! -z "$SECONT_URL" ]]; then
			DOWNLOAD_URL="$FIRST_URL$SECONT_URL"
			break
		fi
	done
}

function parseStage2(){
	cat "$PROJECT_DIR/catalog.xml" | grep "			<string>9.9.$VERSION</string>
				<string>$MODEL</string>
			<string>http://appldnld.apple.com/
\.zip</string>"
}

function showSummary(){
	showLines "*"
	echo "Summary"
	showLines "-"
	echo "Device name : $MODEL"
	echo "iOS version : $VERSION (9.9.$VERSION)"
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
	if [[ -f "$MODEL-$VERSION" ]]; then
		rm "$MODEL-$VERSION"
	fi
	if [[ -f "$MODEL-$VERSION.ota" ]]; then
		rm "$MODEL-$VERSION.ota"
	fi
	if [[ -f "$MODEL-$VERSION.tar" ]]; then
		rm "$MODEL-$VERSION.tar"
	fi
	if [[ -d "$MODEL-$VERSION" ]]; then
		rm -rf "$MODEL-$VERSION"
	fi
	if [[ -d "$MODEL-$VERSION.ota" ]]; then
		rm -rf "$MODEL-$VERSION.ota"
	fi
	if [[ -d "$MODEL-$VERSION.tar" ]]; then
		rm -rf "$MODEL-$VERSION.tar"
	fi
	mv "$PROJECT_DIR/payload" "$MODEL-$VERSION"
	echo "Extracting... (2)"
	"$PROJECT_DIR/ota2tar/src/ota2tar" "$MODEL-$VERSION"
	if [[ -f "$MODEL-$VERSION.tar" ]]; then
		rm "$MODEL-$VERSION"
		echo "Success! Check $OUTPUT_DIRECTORY/$MODEL-$VERSION.tar"
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
buildBinary
downloadUpdate
extractUpdate
