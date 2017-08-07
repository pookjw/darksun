#!/bin/sh
# darksun
# Idea by http://newosxbook.com/articles/OTA3.html

# GM_OTA
# - iOS GM Seed
# - watchOS GM Seed
# - tvOS GM Seed
# - iOS (HomePod) GM Seed
# - iOS 10 Public Beta Seed (But now GM)
# - iOS 9 Public Beta Seed (But now GM)
# - iOS 8 Public Beta Seed (But now GM)
# - watchOS 3 Developer Beta Seed (But now GM)
# - tvOS 10 Developer Beta Seed (But now GM)
GM_OTA="https://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/watch/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/tv/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/audio/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/seed-R40.Subdivide/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/seed-R40.2112/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/watchOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/tvOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
# DB_OTA
# - iOS 11 Developer Beta Seed
# - watchOS 4 Developer Beta Seed
# - tvOS 11 Developer Beta Seed
DB_OTA="https://mesu.apple.com/assets/iOS11DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
https://mesu.apple.com/assets/watchOS4DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/tvOS11DeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
# PB_OTA
# - iOS 11 Public Beta Seed
# - tvOS 11 Public Beta Seed
PB_OTA="https://mesu.apple.com/assets/iOS11PublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml
http://mesu.apple.com/assets/tvOS11PublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
TOOL_VERSION=36

function showHelpMessage(){
	echo "darksun: get whole file system (Version: $TOOL_VERSION)"
	echo "Usage: ./darksun.sh [options...]"
	echo "Options:"
	echo "-n [name]		device identifier (see https://www.theiphonewiki.com/wiki/Models)"
	echo "-v [version]		system version"
	echo "-e [prerequisite]	get delta update file (default: combo)"
	echo "-d			get Developer Beta Firmware (default: GM only)"
	echo "-p			get Public Beta Firmware (default: GM only)"
	echo "-s			search only"
	echo "-u			only show update URL on summary"
	echo "--verbose		run verbose mode"
	echo "--no-ssl		no SSL mode"
	quitTool 1
}

function setOption(){
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

	if [[ "$1" == -e ]]; then
		PREREQUISITE_BUILD="$2"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$2" == -e ]]; then
		PREREQUISITE_BUILD="$3"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$3" == -e ]]; then
		PREREQUISITE_BUILD="$4"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$4" == -e ]]; then
		PREREQUISITE_BUILD="$5"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$5" == -e ]]; then
		PREREQUISITE_BUILD="$6"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$6" == -e ]]; then
		PREREQUISITE_BUILD="$7"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$7" == -e ]]; then
		PREREQUISITE_BUILD="$8"
		SEARCH_DELTA_UPDATE=YES
	fi
	if [[ "$8" == -e ]]; then
		PREREQUISITE_BUILD="$9"
		SEARCH_DELTA_UPDATE=YES
	fi

	if [[ "$1" == "-d" || "$2" == "-d" || "$3" == "-d" || "$4" == "-d" || "$5" == "-d" || "$6" == "-d" || "$7" == "-d" || "$8" == "-d" || "$9" == "-d" ]]; then
		ONLY_DOWNLOAD_DEVELOPER_BETA=YES
		ONLY_DOWNLOAD_PUBLIC_BETA=NO
	fi
	if [[ "$1" == "-p" || "$2" == "-p" || "$3" == "-p" || "$4" == "-p" || "$5" == "-p" || "$6" == "-p" || "$7" == "-p" || "$8" == "-p" || "$9" == "-p" ]]; then
		ONLY_DOWNLOAD_DEVELOPER_BETA=NO
		ONLY_DOWNLOAD_PUBLIC_BETA=YES
	fi
	if [[ "$1" == "--verbose" || "$2" == "--verbose" || "$3" == "--verbose" || "$4" == "--verbose" || "$5" == "--verbose" || "$6" == "--verbose" || "$7" == "--verbose" || "$8" == "--verbose" || "$9" == "--verbose" ]]; then
		VERBOSE=YES
	fi
	if [[ "$1" == "-s" || "$2" == "-s" || "$3" == "-s" || "$4" == "-s" || "$5" == "-s" || "$6" == "-s" || "$7" == "-s" || "$8" == "-s" || "$9" == "-s" ]]; then
		SEARCH_ONLY=YES
	fi
	if [[ "$1" == "-u" || "$2" == "-u" || "$3" == "-u" || "$4" == "-u" || "$5" == "-u" || "$6" == "-u" || "$7" == "-u" || "$8" == "-u" || "$9" == "-u" ]]; then
		SHOW_URL_ONLY=YES
	fi
	if [[ "$1" == "--no-ssl" || "$2" == "--no-ssl" || "$3" == "--no-ssl" || "$4" == "--no-ssl" || "$5" == "--no-ssl" || "$6" == "--no-ssl" || "$7" == "--no-ssl" || "$8" == "--no-ssl" || "$9" == "--no-ssl" ]]; then
		NO_SSL=YES
	fi
	if [[ -z "$MODEL" || -z "$VERSION" ]]; then
		showHelpMessage
	fi
	if [[ "$SEARCH_DELTA_UPDATE" == YES && -z "$PREREQUISITE_BUILD" ]]; then
		showHelpMessage
	fi
	OUTPUT_DIRECTORY="$(pwd)"
	if [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
		echo "$OUTPUT_DIRECTORY: No such file or directory"
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
				echo "Temp folder: $PROJECT_DIR"
			fi
			break
		fi
	done
}

function searchDownloadURL(){
	if [[ ! "$SHOW_URL_ONLY" == YES ]]; then
		echo "Searching... (will take a long time)"
	fi
	if [[ "$ONLY_DOWNLOAD_PUBLIC_BETA" == YES ]]; then
		URL="$PB_OTA"
	elif [[ "$ONLY_DOWNLOAD_DEVELOPER_BETA" == YES ]]; then
		URL="$DB_OTA"
	else
		URL="$GM_OTA"
	fi
	for OTA_URL in $URL; do
		if [[ -f "$PROJECT_DIR/catalog.xml" ]]; then
			rm "$PROJECT_DIR/catalog.xml"
		fi
		if [[ "$NO_SSL" == YES ]]; then
			if [[ "$VERBOSE" == YES ]]; then
				echo "Downloading $OTA_URL"
				curl -k -o "$PROJECT_DIR/catalog.xml" "$OTA_URL"
			else
				curl -k -s -o "$PROJECT_DIR/catalog.xml" "$OTA_URL"
			fi
		else
			if [[ "$VERBOSE" == YES ]]; then
				echo "Downloading $OTA_URL"
				curl -o "$PROJECT_DIR/catalog.xml" "$OTA_URL"
			else
				curl -s -o "$PROJECT_DIR/catalog.xml" "$OTA_URL"
			fi
		fi
		if [[ ! -f "$PROJECT_DIR/catalog.xml" ]]; then
			echo "ERROR : Failed to download."
			quitTool 1
		fi
		parseAsset
		if [[ ! -z "$DOWNLOAD_URL" ]]; then
			BUILD_NUMBER="$(echo "$BUILD_NUMBER_VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			BUILD_NAME="$(echo "$BUILD_NAME_VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			break
		fi
	done
	if [[ -z "$DOWNLOAD_URL" ]]; then
		echo "$MODEL | $VERSION not found."
		#echo "$COUNT" "$PASS_ONCE_0" "$PASS_ONCE_1" "$PASS_ONCE_2" "$PASS_ONCE_3" "$PASS_ONCE_4" "$PASS_ONCE_5" "$PASS_ONCE_6" "$PASS_ONCE_7" "$PASS_ONCE_8" "$PASS_ONCE_9" "$BUILD_NAME_VALUE" "$BUILD_NUMBER_VALUE"
		quitTool 1
	fi
}

function parseAsset(){
	VALUE=
	BUILD_NAME=
	BUILD_NAME_VALUE=
	BUILD_NUMBER=
	BUILD_NUMBER_VALUE=
	COUNT=0
	FOUND_PREREQUISITE_CORRECTLY=NO
	PASS_ONCE_0=NO
	PASS_ONCE_1=NO
	PASS_ONCE_2=NO
	PASS_ONCE_3=NO
	PASS_ONCE_4=NO
	PASS_ONCE_5=NO
	PASS_ONCE_6=NO
	PASS_ONCE_7=NO
	PASS_ONCE_8=NO
	PASS_ONCE_9=NO
	FIRST_URL=
	SECOND_URL=
	DOWNLOAD_URL=
	for VALUE in $(cat "$PROJECT_DIR/catalog.xml"); do
		if [[ "$VERBOSE" == YES ]]; then
			echo "$VALUE"
		fi
		if [[ "$COUNT" == 3 ]]; then
			if [[ "$PASS_ONCE_9" == YES ]]; then
				SECOND_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				PASS_ONCE_9=NO
				DOWNLOAD_URL="$FIRST_URL$SECOND_URL"
				break
			fi
			if [[ "$VALUE" == "<key>__RelativePath</key>" ]]; then
				PASS_ONCE_9=YES
			fi
		elif [[ "$COUNT" == 2 ]]; then
			if [[ "$PASS_ONCE_8" == YES ]]; then
				FIRST_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				PASS_ONCE_8=NO
				COUNT=3
			fi
			if [[ "$VALUE" == "<key>__BaseURL</key>" ]]; then
				PASS_ONCE_8=YES
			fi
		elif [[ "$COUNT" == 1 ]]; then
			if [[ "$PASS_ONCE_7" == YES ]]; then
				if [[ "$VALUE" == "<string>$MODEL</string>" ]]; then
					COUNT=2
				else
					COUNT=0
					BUILD_NUMBER_VALUE=
					FOUND_PREREQUISITE_CORRECTLY=NO
					BUILD_NAME=
				fi
				PASS_ONCE_7=NO
			fi
			if [[ "$PASS_ONCE_6" == YES ]]; then
				PASS_ONCE_6=NO
				PASS_ONCE_7=YES
			fi
			if [[ "$VALUE" == "<key>SupportedDevices</key>" ]]; then
				PASS_ONCE_6=YES
			fi
			if [[ "$PASS_ONCE_5" == YES ]]; then
				if [[ "$VALUE" == "<string>$MODEL</string>" ]]; then
					COUNT=2
				fi
				PASS_ONCE_5=NO
			fi
			if [[ "$PASS_ONCE_4" == YES ]]; then
				PASS_ONCE_4=NO
				PASS_ONCE_5=YES
			fi
			if [[ "$VALUE" == "<key>SupportedDeviceModels</key>" ]]; then
				PASS_ONCE_4=YES
			fi
			if [[ "$PASS_ONCE_3" == YES ]]; then
				BUILD_NAME_VALUE="$VALUE"
				PASS_ONCE_3=NO
			fi
			if [[ "$VALUE" == "<key>SUDocumentationID</key>" ]]; then
				if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
					if [[ "$FOUND_PREREQUISITE_CORRECTLY" == YES ]]; then
						PASS_ONCE_3=YES
					else
						COUNT=0
						BUILD_NUMBER_VALUE=
						FOUND_PREREQUISITE_CORRECTLY=NO
					fi
				else
					PASS_ONCE_3=YES
				fi
			fi
			if [[ "$PASS_ONCE_2" == YES ]]; then
				if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
					if [[ "$VALUE" == "<string>$PREREQUISITE_BUILD</string>" ]]; then
						FOUND_PREREQUISITE_CORRECTLY=YES
					else
						COUNT=0
						BUILD_NUMBER_VALUE=
					fi
				else
					if [[ ! "$VALUE" == "<string>10A403</string>" && ! "$VALUE" == "<string>10A405</string>" && ! "$VALUE" == "<string>10A406</string>" && ! "$VALUE" == "<string>10A407</string>" ]]; then # for iOS 8.4.1
						COUNT=0
						BUILD_NUMBER_VALUE=
					fi
				fi
				PASS_ONCE_2=NO
			fi
			if [[ "$VALUE" == "<key>PrerequisiteBuild</key>" ]]; then
				PASS_ONCE_2=YES
			fi
		elif [[ "$COUNT" == 0 ]]; then
			if [[ "$PASS_ONCE_1" == YES ]]; then
				if [[ "$VALUE" == "<string>9.9.$VERSION</string>" ]]; then # for iOS 10 or later
					COUNT=1
				elif [[ "$VALUE" == "<string>$VERSION</string>" ]]; then # for iOS 8~9, watchOS
					COUNT=1
				else
					BUILD_NUMBER_VALUE=
				fi
				PASS_ONCE_1=NO
			fi
			if [[ "$VALUE" == "<key>OSVersion</key>" ]]; then
				PASS_ONCE_1=YES
			fi
			if [[ "$PASS_ONCE_0" == YES ]]; then
				BUILD_NUMBER_VALUE="$VALUE"
				PASS_ONCE_0=NO
			fi
			if [[ "$VALUE" == "<key>Build</key>" ]]; then
				PASS_ONCE_0=YES
			fi
		fi
	done
}

function showSummary(){
	if [[ "$SHOW_URL_ONLY" == YES ]]; then
		echo "$DOWNLOAD_URL"
	else
		showLines "*"
		echo "SUMMARY (darksun-$TOOL_VERSION)"
		showLines "-"
		echo "Device name: $MODEL"
		echo "Version: $VERSION ($BUILD_NAME)"
		echo "Build: $BUILD_NUMBER"
		if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
			echo "Prerequisite: $PREREQUISITE_BUILD"
			echo "Update type: delta"
		else
			echo "Update type: combo"
		fi
		echo "Update URL: $DOWNLOAD_URL"
		if [[ ! "$SEARCH_ONLY" == YES ]]; then
			echo "Output: $OUTPUT_DIRECTORY"
		fi
		showLines "*"
	fi
	if [[ "$SEARCH_ONLY" == YES ]]; then
		quitTool 0
	fi
}

function downloadBinary(){
	echo "Downloading OTApack... (http://newosxbook.com/articles/OTA3.html)"
	for FILE in OTApack OTApack.tar; do
		if [[ -d "$PROJECT_DIR/$FILE" || -f "$PROJECT_DIR/$FILE" ]]; then
			rm -rf "$PROJECT_DIR/$FILE"
		fi
	done
	# See http://newosxbook.com/articles/OTA3.html
	if [[ "$NO_SSL" == YES ]]; then
		if [[ "$VERBOSE" == YES ]]; then
			curl -k -o "$PROJECT_DIR/OTApack.tar" http://newosxbook.com/files/OTApack.tar
		else
			curl -k -# -o "$PROJECT_DIR/OTApack.tar" http://newosxbook.com/files/OTApack.tar
		fi
	else
		if [[ "$VERBOSE" == YES ]]; then
			curl -o "$PROJECT_DIR/OTApack.tar" http://newosxbook.com/files/OTApack.tar
		else
			curl -# -o "$PROJECT_DIR/OTApack.tar" http://newosxbook.com/files/OTApack.tar
		fi
	fi
	if [[ ! -f "$PROJECT_DIR/OTApack.tar" ]]; then
		echo "ERROR: Failed to download OTApack.tar."
		quitTool 1
	fi
	mkdir "$PROJECT_DIR/OTApack"
	cd "$PROJECT_DIR/OTApack"
	if [[ "$VERBOSE" == YES ]]; then
		tar xvf "$PROJECT_DIR/OTApack.tar"
	else
		tar xf "$PROJECT_DIR/OTApack.tar"
	fi
	if [[ -z "$(ls "$PROJECT_DIR/OTApack")" ]]; then
		echo "ERROR: Failed to extract OTApack.tar."
		quitTool 1
	fi
}

function downloadUpdate(){
	if [[ -f "$PROJECT_DIR/update.zip" ]]; then
		rm "$PROJECT_DIR/update.zip"
	fi
	echo "Downloading update file..."
	if [[ "$NO_SSL" == YES ]]; then
		if [[ "$VERBOSE" == YES ]]; then
			curl -k -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
		else
			curl -k -# -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
		fi
	else
		if [[ "$VERBOSE" == YES ]]; then
			curl -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
		else
			curl -# -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_URL"
		fi
	fi
	if [[ ! -f "$PROJECT_DIR/update.zip" ]]; then
		echo "ERROR: Can't download update file."
		quitTool 1
	fi
}

function extractUpdate(){
	echo "Extracting... (1)"
	if [[ "$VERBOSE" == YES ]]; then
		unzip -o -d "$PROJECT_DIR/update" "$PROJECT_DIR/update.zip"
	else
		unzip -qq -o -d "$PROJECT_DIR/update" "$PROJECT_DIR/update.zip"
	fi
	cd "$OUTPUT_DIRECTORY"
	echo "Extracting... (2)"
	for FILE in app_patches links.txt patches payload removed.txt; do
		if [[ -d "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" || -f "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" ]]; then
			if [[ -d "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE" || -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE" ]]; then
				rm -rf "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
				echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
			fi
			mv "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
		fi
	done
	if [[ -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-payload" ]]; then
		for FILE in "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-system" "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb.xz" "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb"; do
			if [[ -d "$FILE" || -f "$FILE" ]]; then
				rm -rf "$FILE"
				echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$FILE"
			fi
		done
		if [[ "$VERBOSE" == YES ]]; then
			"$PROJECT_DIR/OTApack/pbzx" < "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-payload" > "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb.xz"
			xz --decompress "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb.xz"
		else
			if [[ -f "$PROJECT_DIR/script" ]]; then
				rm "$PROJECT_DIR/script"
			fi
			echo "\"$PROJECT_DIR/OTApack/pbzx\" < \"$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-payload\" > \"$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb.xz\"" >> "$PROJECT_DIR/script"
			chmod +x "$PROJECT_DIR/script"
			"$PROJECT_DIR/script" > /dev/null 2>&1
			xz --decompress "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb.xz" > /dev/null 2>&1
		fi
		mkdir "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-system"
		cd "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-system"
		if [[ "$VERBOSE" == YES ]]; then
			"$PROJECT_DIR/OTApack/otaa" -e '*' "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb"
		else
			"$PROJECT_DIR/OTApack/otaa" -e '*' "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb" > /dev/null 2>&1
		fi
		rm "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-payload"
		rm "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-pb"
	fi
	if [[ ! -d "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-app_patches" && ! -d "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-patches" && ! -d "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-system" ]]; then
		echo "ERROR!"
		quitTool 1
	else
		echo "Done."
		quitTool 0
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
	if [[ "$1" == 0 ]]; then
		if [[ -d "$PROJECT_DIR" && ! -z "$PROJECT_DIR" ]]; then
			rm -rf "$PROJECT_DIR"
		fi
	fi
	exit "$1"
}

#######################################

setOption "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
setProjectPath
searchDownloadURL
showSummary
downloadBinary
downloadUpdate
extractUpdate
