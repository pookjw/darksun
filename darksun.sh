#!/bin/sh
# darksun
# Idea by http://newosxbook.com/articles/OTA3.html
TOOL_VERSION=58

# GM_OTA
# - iOS GM Seed
# - watchOS GM Seed
# - tvOS GM Seed
# - iOS (HomePod) GM Seed
# - iOS 10 Public beta Seed (But now GM)
# - iOS 9 Public beta Seed (But now GM)
# - iOS 8 Public beta Seed (But now GM)
# - watchOS 3 Developer beta Seed (But now GM)
# - tvOS 10 Developer beta Seed (But now GM)
GM_OTA="https://mesu.apple.com/assets
https://mesu.apple.com/assets/watch
http://mesu.apple.com/assets/tv
http://mesu.apple.com/assets/audio
https://mesu.apple.com/assets/iOSPublicSeed
https://mesu.apple.com/assets/seed-R40.Subdivide
https://mesu.apple.com/assets/seed-R40.2112
https://mesu.apple.com/assets/watchOSDeveloperSeed
http://mesu.apple.com/assets/tvOSDeveloperSeed"
# DB_OTA
# - iOS 11 Developer beta Seed
# - watchOS 4 Developer beta Seed
# - tvOS 11 Developer beta Seed
DB_OTA="https://mesu.apple.com/assets/iOS11DeveloperSeed
https://mesu.apple.com/assets/watchOS4DeveloperSeed
http://mesu.apple.com/assets/tvOS11DeveloperSeed"
# PB_OTA
# - iOS 11 Public beta Seed
# - tvOS 11 Public beta Seed
PB_OTA="https://mesu.apple.com/assets/iOS11PublicSeed
http://mesu.apple.com/assets/tvOS11PublicSeed"
DOCUMENTATION_NAME_FILTER_LIST="X Y Z"

function showHelpMessage(){
	echo "darksun: get whole file system (Version: $TOOL_VERSION)"
	echo "Usage: ./darksun.sh [options...]"
	echo "Options:"
	echo "-n [name]		device identifier (see https://www.theiphonewiki.com/wiki/Models)"
	echo "-v [version]		system version"
	echo "-e [prerequisite]	get Short update file (default: Full)"
	echo "-d			get Developer beta Firmware (default: GM only)"
	echo "-p			get Public beta Firmware (default: GM only)"
	echo "-m [mobileconfig]	get Firmware from OTA Profile(.mobileconfig) (default: GM only)"
	echo "-c [url]		get Firmware from custom assets URL"
	echo "-i			run interface mode"
	echo "-s			search only"
	echo "-u			only show update URL on summary"
	echo "--loop			search ota infinitely until update found"
	echo "--verbose		run verbose mode"
	echo "--no-ssl		no SSL mode"
	echo "--do-not-clean		do not clean temp dir on quit"
	quitTool 1
}

function setOption(){
	if [[ "$1" == "--verbose" || "$2" == "--verbose" || "$3" == "--verbose" || "$4" == "--verbose" || "$5" == "--verbose" || "$6" == "--verbose" || "$7" == "--verbose" || "$8" == "--verbose" || "$9" == "--verbose" ]]; then
		VERBOSE=YES
	else
		VERBOSE=NO
	fi
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
	if [[ -z "$SEARCH_DELTA_UPDATE" ]]; then
		SEARCH_DELTA_UPDATE=NO
	fi

	if [[ "$1" == "-i" || "$2" == "-i" || "$3" == "-i" || "$4" == "-i" || "$5" == "-i" || "$6" == "-i" || "$7" == "-i" || "$8" == "-i" || "$9" == "-i" ]]; then
		INTERFACE_MODE=YES
	else
		INTERFACE_MODE=NO
	fi
	if [[ "$1" == "-d" || "$2" == "-d" || "$3" == "-d" || "$4" == "-d" || "$5" == "-d" || "$6" == "-d" || "$7" == "-d" || "$8" == "-d" || "$9" == "-d" ]]; then
		OTA_PROFILE=DEVELOPER
	fi
	if [[ "$1" == "-p" || "$2" == "-p" || "$3" == "-p" || "$4" == "-p" || "$5" == "-p" || "$6" == "-p" || "$7" == "-p" || "$8" == "-p" || "$9" == "-p" ]]; then
		OTA_PROFILE=PUBLIC
	fi
	if [[ "$1" == -m ]]; then
		PATH_MOBILECONFIG="$2"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$2" == -m ]]; then
		PATH_MOBILECONFIG="$3"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$3" == -m ]]; then
		PATH_MOBILECONFIG="$4"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$4" == -m ]]; then
		PATH_MOBILECONFIG="$5"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$5" == -m ]]; then
		PATH_MOBILECONFIG="$6"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$6" == -m ]]; then
		PATH_MOBILECONFIG="$7"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$7" == -m ]]; then
		PATH_MOBILECONFIG="$8"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$8" == -m ]]; then
		PATH_MOBILECONFIG="$9"
		OTA_PROFILE=MOBILE_CONFIG
	fi
	if [[ "$OTA_PROFILE" == MOBILE_CONFIG ]]; then
		if [[ -z "$PATH_MOBILECONFIG" ]]; then
			showHelpMessage
		fi
		if [[ ! -f "$PATH_MOBILECONFIG" ]]; then
			echo "$PATH_MOBILECONFIG: No such file."
			quitTool 1
		fi
		parseMobileConfig
		if [[ -z "$MOBILE_CONFIG_OTA" ]]; then
			echo "ERROR: Invalid mobileconfig."
			quitTool 1
		fi
	fi
	if [[ "$1" == -c ]]; then
		CUSTOM_OTA="$2"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$2" == -c ]]; then
		CUSTOM_OTA="$3"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$3" == -c ]]; then
		CUSTOM_OTA="$4"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$4" == -c ]]; then
		CUSTOM_OTA="$5"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$5" == -c ]]; then
		CUSTOM_OTA="$6"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$6" == -c ]]; then
		CUSTOM_OTA="$7"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$7" == -c ]]; then
		CUSTOM_OTA="$8"
		OTA_PROFILE=CUSTOM
	fi
	if [[ "$8" == -c ]]; then
		CUSTOM_OTA="$9"
		OTA_PROFILE=CUSTOM
	fi
	if [[ -z "$OTA_PROFILE" ]]; then
		OTA_PROFILE=GM
	fi
	if [[ "$1" == "-s" || "$2" == "-s" || "$3" == "-s" || "$4" == "-s" || "$5" == "-s" || "$6" == "-s" || "$7" == "-s" || "$8" == "-s" || "$9" == "-s" ]]; then
		SEARCH_ONLY=YES
	else
		SEARCH_ONLY=NO
	fi
	if [[ "$1" == "-u" || "$2" == "-u" || "$3" == "-u" || "$4" == "-u" || "$5" == "-u" || "$6" == "-u" || "$7" == "-u" || "$8" == "-u" || "$9" == "-u" ]]; then
		SHOW_URL_ONLY=YES
	else
		SHOW_URL_ONLY=NO
	fi
	if [[ "$1" == "--loop" || "$2" == "--loop" || "$3" == "--loop" || "$4" == "--loop" || "$5" == "--loop" || "$6" == "--loop" || "$7" == "--loop" || "$8" == "--loop" || "$9" == "--loop" ]]; then
		SEARCH_LOOP=YES
	else
		SEARCH_LOOP=NO
	fi
	if [[ "$1" == "--no-ssl" || "$2" == "--no-ssl" || "$3" == "--no-ssl" || "$4" == "--no-ssl" || "$5" == "--no-ssl" || "$6" == "--no-ssl" || "$7" == "--no-ssl" || "$8" == "--no-ssl" || "$9" == "--no-ssl" ]]; then
		NO_SSL=YES
	else
		NO_SSL=NO
	fi
	if [[ "$1" == "--do-not-clean" || "$2" == "--do-not-clean" || "$3" == "--do-not-clean" || "$4" == "--do-not-clean" || "$5" == "--do-not-clean" || "$6" == "--do-not-clean" || "$7" == "--do-not-clean" || "$8" == "--do-not-clean" || "$9" == "--do-not-clean" ]]; then
		DO_NOT_CLEAN_TEMP_DIR=YES
	else
		DO_NOT_CLEAN_TEMP_DIR=NO
	fi
	if [[ "$INTERFACE_MODE" == YES ]]; then
		TITLE_NUM=1
	fi
	if [[ ! "$INTERFACE_MODE" == YES ]]; then
		if [[ -z "$MODEL" || -z "$VERSION" ]]; then
			showHelpMessage
		fi
		if [[ "$SEARCH_DELTA_UPDATE" == YES && -z "$PREREQUISITE_BUILD" ]]; then
			showHelpMessage
		fi
	fi
	if [[ ! "$SEARCH_ONLY" == YES ]]; then
		OUTPUT_DIRECTORY="$(pwd)"
		if [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
			if [[ "$INTERFACE_MODE" == YES ]]; then
				OUTPUT_DIRECTORY=
			else
				echo "$OUTPUT_DIRECTORY: No such file or directory"
				quitTool 1
			fi
		fi
	fi
}

function setProjectPath(){
	COUNT=1
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
	if [[ "$INTERFACE_MODE" == YES ]]; then
		mkdir -p "$PROJECT_DIR/TitleBar"
	fi
}

function showInterface(){
	addTitleBar "Home"
	while(true); do
		clear
		showLines "*"
		showTitleBar
		showLines "-"
		if [[ -z "$MODEL" ]]; then
			echo "(1) device: (undefined)"
		else
			echo "(1) device: $MODEL"
		fi
		if [[ -z "$VERSION" ]]; then
			echo "(2) version: (undefined)"
		else
			echo "(2) version: $VERSION"
		fi
		if [[ -z "$OUTPUT_DIRECTORY" ]]; then
			echo "(3) output: (undefined)"
		else
			echo "(3) output: $OUTPUT_DIRECTORY"
		fi
		if [[ -z "$OTA_PROFILE" ]]; then
			echo "(4) profile: (undefined)"
		elif [[ "$OTA_PROFILE" == DEVELOPER ]]; then
			echo "(4) profile: Developer beta"
		elif [[ "$OTA_PROFILE" == PUBLIC ]]; then
			echo "(4) profile: Public beta"
		elif [[ "$OTA_PROFILE" == CUSTOM ]]; then
			echo "(4) profile: Custom ($CUSTOM_OTA)"
		elif [[ "$OTA_PROFILE" == MOBILE_CONFIG ]]; then
			echo "(4) profile: OTA Profile ($MOBILE_CONFIG_OTA)"
		else
			echo "(4) profile: $OTA_PROFILE"
		fi
		echo "(5) short(delta): $SEARCH_DELTA_UPDATE"
		if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
			if [[ -z "$PREREQUISITE_BUILD" ]]; then
				echo "(6) prerequisite: (undefined)"
			else
				echo "(6) prerequisite: $PREREQUISITE_BUILD"
			fi
		fi
		showLines "-"
		if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
			echo "Available commands: 1~6, start, debug, info, exit"
		else
			echo "Available commands: 1~5, start, debug, info, exit"
		fi
		showLines "*"
		read -p "- " ANSWER

		if [[ "$ANSWER" == 1 ]]; then
			read -p "MODEL=" MODEL
		elif [[ "$ANSWER" == 2 ]]; then
			read -p "VERSION=" VERSION
		elif [[ "$ANSWER" == 3 ]]; then
			read -p "OUTPUT_DIRECTORY=" OUTPUT_DIRECTORY
			if [[ -z "$OUTPUT_DIRECTORY" ]]; then
				:
			elif [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
				echo "$OUTPUT_DIRECTORY: No such directory."
				OUTPUT_DIRECTORY=
				showPA2C
			fi
		elif [[ "$ANSWER" == 4 ]]; then
			addTitleBar "Select Profile"
			while(true); do
				clear
				showLines "*"
				showTitleBar
				showLines "-"
				echo "(1) GM"
				echo "(2) Developer beta"
				echo "(3) Public beta"
				echo "(4) OTA Profile"
				echo "(5) Custom"
				showLines "-"
				echo "Available commands: 1~4, break, exit"
				showLines "*"
				read -p "- " ANSWER

				if [[ "$ANSWER" == 1 ]]; then
					OTA_PROFILE=GM
					backTitleBar
					break
				elif [[ "$ANSWER" == 2 ]]; then
					OTA_PROFILE=DEVELOPER
					backTitleBar
					break
				elif [[ "$ANSWER" == 3 ]]; then
					OTA_PROFILE=PUBLIC
					backTitleBar
					break
				elif [[ "$ANSWER" == 4 ]]; then
					read -p "PATH_MOBILECONFIG=" PATH_MOBILECONFIG
					if [[ -z "$PATH_MOBILECONFIG" ]]; then
						backTitleBar
						break
					else
						if [[ -f "$PATH_MOBILECONFIG" ]]; then
							parseMobileConfig
							if [[ -z "$MOBILE_CONFIG_OTA" ]]; then
								echo "ERROR: Invalid mobileconfig."
								OTA_PROFILE=GM
								showPA2C
							else
								OTA_PROFILE=MOBILE_CONFIG
							fi
						else
							echo "$PATH_MOBILECONFIG: No such file."
							showPA2C
						fi
					fi
					backTitleBar
					break
				elif [[ "$ANSWER" == 5 ]]; then
					read -p "CUSTOM_OTA=" CUSTOM_OTA
					if [[ -z "$CUSTOM_OTA" ]]; then
						OTA_PROFILE=GM
					else
						OTA_PROFILE=CUSTOM
					fi
					backTitleBar
					break
				elif [[ "$ANSWER" == break ]]; then
					backTitleBar
					break
				elif [[ "$ANSWER" == exit ]]; then
					quitTool 0
				elif [[ -z "$ANSWER" ]]; then
					:
				else
					echo "$ANSWER: Command not found."
					showPA2C
				fi
			done
		elif [[ "$ANSWER" == 5 ]]; then
			if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
				SEARCH_DELTA_UPDATE=NO
				PREREQUISITE_BUILD=
			else
				SEARCH_DELTA_UPDATE=YES
			fi
		elif [[ "$ANSWER" == 6 && "$SEARCH_DELTA_UPDATE" == YES ]]; then
			read -p "PREREQUISITE_BUILD=" PREREQUISITE_BUILD
		elif [[ "$ANSWER" == start ]]; then
			if [[ -z "$MODEL" || -z "$VERSION" ]]; then
				echo "Please define all values."
				showPA2C
			else
				INTERFACE_VALUE_ERROR=NO
				if [[ "$SEARCH_DELTA_UPDATE" == YES  && -z "$PREREQUISITE_BUILD" ]]; then
					INTERFACE_VALUE_ERROR=YES
				fi
				if [[ ! "$SEARCH_ONLY" == YES && -z "$OUTPUT_DIRECTORY" ]]; then
					INTERFACE_VALUE_ERROR=YES
				fi
				if [[ "$INTERFACE_VALUE_ERROR" == YES ]]; then
					echo "Please define all values."
					showPA2C 
				else
					backTitleBar
					break
				fi
			fi
		elif [[ "$ANSWER" == debug ]]; then
			addTitleBar "Debug Settings"
			while(true); do
				clear
				showLines "*"
				showTitleBar
				showLines "-"
				echo "(1) search only: $SEARCH_ONLY"
				echo "(2) url only on summary: $SHOW_URL_ONLY"
				echo "(3) verbose: $VERBOSE"
				echo "(4) search ota infinitely: $SEARCH_LOOP"
				echo "(5) no ssl: $NO_SSL"
				echo "(6) do not clean: $DO_NOT_CLEAN_TEMP_DIR"
				echo "(7) addTitleBar"
				echo "(8) backTitleBar"
				showLines "-"
				echo "Available commands: 1~8, break, exit"
				showLines "*"

				read -p "- " ANSWER
				if [[ "$ANSWER" == 1 ]]; then
					if [[ "$SEARCH_ONLY" == YES ]]; then
						SEARCH_ONLY=NO
					else
						SEARCH_ONLY=YES
					fi
				elif [[ "$ANSWER" == 2 ]]; then
					if [[ "$SHOW_URL_ONLY" == YES ]]; then
						SHOW_URL_ONLY=NO
					else
						SHOW_URL_ONLY=YES
					fi
				elif [[ "$ANSWER" == 3 ]]; then
					if [[ "$VERBOSE" == YES ]]; then
						VERBOSE=NO
					else
						VERBOSE=YES
					fi
				elif [[ "$ANSWER" == 4 ]]; then
					if [[ "$SEARCH_LOOP" == YES ]]; then
						SEARCH_LOOP=NO
					else
						SEARCH_LOOP=YES
					fi
				elif [[ "$ANSWER" == 5 ]]; then
					if [[ "$NO_SSL" == YES ]]; then
						NO_SSL=NO
					else
						NO_SSL=YES
					fi
				elif [[ "$ANSWER" == 6 ]]; then
					if [[ "$DO_NOT_CLEAN_TEMP_DIR" == YES ]]; then
						DO_NOT_CLEAN_TEMP_DIR=NO
					else
						DO_NOT_CLEAN_TEMP_DIR=YES
					fi
				elif [[ "$ANSWER" == 7 ]]; then
					read -p "addTitleBar:" ANSWER
					addTitleBar "$ANSWER"
				elif [[ "$ANSWER" == 8 ]]; then
					backTitleBar
				elif [[ "$ANSWER" == break ]]; then
					backTitleBar
					break
				elif [[ "$ANSWER" == exit ]]; then
					quitTool 0
				elif [[ -z "$ANSWER" ]]; then
					:
				else
					echo "$ANSWER: Command not found."
					showPA2C
				fi
			done
		elif [[ "$ANSWER" == info ]]; then
			addTitleBar "Info"
			clear
			showLines "*"
			showTitleBar
			showLines "-"
			echo "darksun (Version: $TOOL_VERSION)"
			echo "developed by pookjw (Twitter: @pookjw)"
			echo
			echo "GitHub: https://github.com/pookjw/darksun"
			echo "darksun uses OTAPack (http://newosxbook.com/articles/OTA3.html)"
			showLines "*"
			showPA2C
			backTitleBar
		elif [[ "$ANSWER" == exit ]]; then
			quitTool 0
		elif [[ -z "$ANSWER" ]]; then
			:
		else
			echo "$ANSWER: Command not found."
			showPA2C
		fi
	done
}

function searchDownloadURL(){
	while(true); do
		if [[ ! "$SHOW_URL_ONLY" == YES ]]; then
			if [[ "$SEARCH_LOOP" == YES ]]; then
				echo "Searching..."
			else
				echo "Searching... (will take a long time)"
			fi
		fi
		if [[ "$OTA_PROFILE" == DEVELOPER ]]; then
			URL="$DB_OTA"
		elif [[ "$OTA_PROFILE" == PUBLIC ]]; then
			URL="$PB_OTA"
		elif [[ "$OTA_PROFILE" == GM ]]; then
			URL="$GM_OTA"
		elif [[ "$OTA_PROFILE" == MOBILE_CONFIG ]]; then
			URL="$MOBILE_CONFIG_OTA" 
		elif [[ "$OTA_PROFILE" == CUSTOM ]]; then
			URL="$CUSTOM_OTA"
		fi
		for OTA_URL in $URL; do
			if [[ -f "$PROJECT_DIR/catalog.xml" ]]; then
				rm "$PROJECT_DIR/catalog.xml"
			fi
			if [[ "$NO_SSL" == YES ]]; then
				if [[ "$VERBOSE" == YES ]]; then
					echo "Downloading $OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
					curl -k -o "$PROJECT_DIR/catalog.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
				else
					curl -k -s -o "$PROJECT_DIR/catalog.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
				fi
			else
				if [[ "$VERBOSE" == YES ]]; then
					echo "Downloading $OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
					curl -o "$PROJECT_DIR/catalog.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
				else
					curl -s -o "$PROJECT_DIR/catalog.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
				fi
			fi
			if [[ ! -f "$PROJECT_DIR/catalog.xml" ]]; then
				echo "ERROR : Failed to download."
				quitTool 1
			fi
			parseAsset
			if [[ ! -z "$DOWNLOAD_FIRMWARE_URL" ]]; then
				BUILD_NUMBER="$(echo "$BUILD_NUMBER_VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				BUILD_NAME="$(echo "$BUILD_NAME_VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				FINAL_OTA_URL="$OTA_URL"
				break
			fi
		done
		if [[ -z "$DOWNLOAD_FIRMWARE_URL" ]]; then
			if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
				echo "$MODEL-$VERSION (pre: $PREREQUISITE_BUILD) is not found."
			else
				echo "$MODEL-$VERSION is not found."
			fi
			if [[ ! "$SEARCH_LOOP" == YES ]]; then
				quitTool 1
			fi
		else
			for OTA_URL in $URL; do
				if [[ -f "$PROJECT_DIR/documentation.xml" ]]; then
					rm "$PROJECT_DIR/documentation.xml"
				fi
				if [[ "$NO_SSL" == YES ]]; then
					if [[ "$VERBOSE" == YES ]]; then
						echo "Downloading $OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
						curl -k -o "$PROJECT_DIR/documentation.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
					else
						curl -k -s -o "$PROJECT_DIR/documentation.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
					fi
				else
					if [[ "$VERBOSE" == YES ]]; then
						echo "Downloading $OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
						curl -o "$PROJECT_DIR/documentation.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
					else
						curl -s -o "$PROJECT_DIR/documentation.xml" "$OTA_URL/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
					fi
				fi
				if [[ -f "$PROJECT_DIR/documentation.xml" ]]; then
					parseDocumentation
					if [[ ! -z "$DOWNLOAD_DOCUMENTATION_URL" ]]; then
						break
					fi
				fi
			done
			break
		fi
	done
}

function parseMobileConfig(){
	VALUE=
	MOBILE_CONFIG_OTA=
	PASS_ONCE_0=NO
	for VALUE in $(strings $PATH_MOBILECONFIG); do
		if [[ "$VERBOSE" == YES ]]; then
			echo "$VALUE"
		fi
		if [[ "$PASS_ONCE_0" == YES ]]; then
			MOBILE_CONFIG_OTA="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
			PASS_ONCE_0=NO
			break
		fi
		if [[ "$VALUE" == "<key>MobileAssetServerURL-com.apple.MobileAsset.SoftwareUpdate</key>" ]]; then
			PASS_ONCE_0=YES
		fi
	done
	if [[ "$VERBOSE" == YES ]]; then
		echo "MOBILE_CONFIG_OTA=$MOBILE_CONFIG_OTA"
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
	FOUND_MODEL_CORRECTLY_AS_MODEL=NO
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
	PASS_ONCE_10=NO
	FIRST_URL=
	SECOND_URL=
	DOWNLOAD_FIRMWARE_URL=
	for VALUE in $(cat "$PROJECT_DIR/catalog.xml"); do
		if [[ "$VERBOSE" == YES ]]; then
			echo "$VALUE"
		fi
		if [[ "$COUNT" == 2 ]]; then
			if [[ "$PASS_ONCE_10" == YES ]]; then
				SECOND_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				PASS_ONCE_10=NO
				DOWNLOAD_FIRMWARE_URL="$FIRST_URL$SECOND_URL"
				break
			fi
			if [[ "$VALUE" == "<key>__RelativePath</key>" ]]; then
				PASS_ONCE_10=YES
			fi
			if [[ "$PASS_ONCE_9" == YES ]]; then
				FIRST_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				PASS_ONCE_9=NO
			fi
			if [[ "$VALUE" == "<key>__BaseURL</key>" ]]; then
				PASS_ONCE_9=YES
			fi
			if [[ "$PASS_ONCE_8" == YES ]]; then
				PASS_ONCE_8=NO
				DOWNLOAD_FIRMWARE_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
				break
			fi
			if [[ "$VALUE" == "<key>RealUpdateURL</key>" ]]; then # for iOS 7.1.2 (pre: 7.1.1_11D201)
				PASS_ONCE_8=YES
			fi
		elif [[ "$COUNT" == 1 ]]; then
			if [[ "$PASS_ONCE_7" == YES ]]; then
				if [[ "$VALUE" == "<string>$MODEL</string>" ]]; then
					COUNT=2
				else
					if [[ "$FOUND_MODEL_CORRECTLY_AS_MODEL" == YES ]]; then
						MODEL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
						COUNT=2
					else
						COUNT=0
						BUILD_NUMBER_VALUE=
						FOUND_PREREQUISITE_CORRECTLY=NO
						BUILD_NAME=
					fi
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
					FOUND_MODEL_CORRECTLY_AS_MODEL=YES
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
					if [[ ! "$VALUE" == "<string>10A403</string>" && ! "$VALUE" == "<string>10A405</string>" && ! "$VALUE" == "<string>10A406</string>" && ! "$VALUE" == "<string>10A407</string>" ]]; then # for iOS 7.1.2, 8.4.1
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

function parseDocumentation(){
	VALUE=
	COUNT=0
	DOCUMENTATION_NAME=
	DOCUMENTATION_DESCRIPTION=
	PASS_ONCE_0=NO
	PASS_ONCE_1=NO
	PASS_ONCE_2=NO
	PASS_ONCE_3=NO
	PASS_ONCE_4=NO
	PASS_ONCE_5=NO
	MODEL_TYPE=
	FIRST_URL=
	SECOND_URL=
	DOWNLOAD_DOCUMENTATION_URL=
	if [[ ! -z "$(echo $MODEL | grep iPad)" ]]; then
		MODEL_TYPE=iPad
	elif [[ ! -z "$(echo $MODEL | grep iPhone)" ]]; then
		MODEL_TYPE=iPhone
	elif [[ ! -z "$(echo $MODEL | grep iPod)" ]]; then
		MODEL_TYPE=iPod
	elif [[ ! -z "$(echo $MODEL | grep AudioAccessory)" ]]; then #HomePod
		MODEL_TYPE=AudioAccessory
	fi
	if [[ "$VERBOSE" == YES ]]; then
		echo "MODEL_TYPE=$MODEL_TYPE"
	fi
	if [[ ! -z "$MODEL_TYPE" ]]; then
		for VALUE in $(cat "$PROJECT_DIR/documentation.xml"); do
			if [[ "$VERBOSE" == YES ]]; then
				echo "$VALUE"
			fi
			if [[ "$COUNT" == 3 ]]; then
				if [[ "$PASS_ONCE_4" == YES ]]; then
					SECOND_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
					PASS_ONCE_4=NO
					DOWNLOAD_DOCUMENTATION_URL="$FIRST_URL$SECOND_URL"
					break
				fi
				if [[ "$VALUE" == "<key>__RelativePath</key>" ]]; then
					PASS_ONCE_4=YES
				fi
				if [[ "$PASS_ONCE_3" == YES ]]; then
					FIRST_URL="$(echo "$VALUE" | cut -d">" -f2 | cut -d"<" -f1)"
					PASS_ONCE_3=NO
				fi
				if [[ "$VALUE" == "<key>__BaseURL</key>" ]]; then
					PASS_ONCE_3=YES
				fi
			elif [[ "$COUNT" == 2 ]]; then
				if [[ "$PASS_ONCE_2" == YES ]]; then
					if [[ "$VALUE" == "<string>$BUILD_NAME</string>" ]]; then
						COUNT=3
					else
						COUNT=0
					fi
					PASS_ONCE_2=NO
				fi
				if [[ "$VALUE" == "<key>SUDocumentationID</key>" ]]; then
					PASS_ONCE_2=YES
				fi
			elif [[ "$COUNT" == 1 ]]; then
				if [[ "$PASS_ONCE_1" == YES ]]; then
					if [[ "$VALUE" == "<string>$VERSION</string>" ]]; then
						COUNT=2
					else	
						COUNT=0
					fi
					PASS_ONCE_1=NO
				fi
				if [[ "$VALUE" == "<key>OSVersion</key>" ]]; then
					PASS_ONCE_1=YES
				fi
			elif [[ "$COUNT" == 0 ]]; then
				if [[ "$PASS_ONCE_0" == YES ]]; then
					if [[ "$VALUE" == "<string>$MODEL_TYPE</string>" ]]; then
						COUNT=1
					fi
					PASS_ONCE_0=NO
				fi
				if [[ "$VALUE" == "<key>Device</key>" ]]; then
					PASS_ONCE_0=YES
				fi
			fi
		done
	fi
	if [[ ! -z "$DOWNLOAD_DOCUMENTATION_URL" ]]; then
		if [[ -f "$PROJECT_DIR/documentation.zip" ]]; then
			rm "$PROJECT_DIR/documentation.zip"
		fi
		if [[ "$NO_SSL" == YES ]]; then
			if [[ "$VERBOSE" == YES ]]; then
				curl -k -o "$PROJECT_DIR/documentation.zip" "$DOWNLOAD_DOCUMENTATION_URL"
			else
				curl -k -s -o "$PROJECT_DIR/documentation.zip" "$DOWNLOAD_DOCUMENTATION_URL"
			fi
		else
			if [[ "$VERBOSE" == YES ]]; then
				curl -o "$PROJECT_DIR/documentation.zip" "$DOWNLOAD_DOCUMENTATION_URL"
			else
				curl -s -o "$PROJECT_DIR/documentation.zip" "$DOWNLOAD_DOCUMENTATION_URL"
			fi
		fi
		if [[ "$VERBOSE" == YES ]]; then
			unzip -o -d "$PROJECT_DIR/documentation" "$PROJECT_DIR/documentation.zip"
		else
			unzip -qq -o -d "$PROJECT_DIR/documentation" "$PROJECT_DIR/documentation.zip"
		fi
		if [[ -f "$PROJECT_DIR/documentation/AssetData/en.lproj/documentation.strings" ]]; then
			DOCUMENTATION_NAME="$(strings "$PROJECT_DIR/documentation/AssetData/en.lproj/documentation.strings" | grep "$VERSION")"
			if [[ -z "$DOCUMENTATION_NAME" ]]; then # for HomePod 11.2 beta 1
				DOCUMENTATION_NAME="$(strings "$PROJECT_DIR/documentation/AssetData/en.lproj/documentation.strings" | grep HomePod)" 
			fi
			for VALUE in $DOCUMENTATION_NAME_FILTER_LIST; do
				DOCUMENTATION_NAME="$(echo "$DOCUMENTATION_NAME" | cut -d"$VALUE" -f2)"
			done
		fi
	fi
}

function showSummary(){
	if [[ "$SHOW_URL_ONLY" == YES ]]; then
		echo "$DOWNLOAD_FIRMWARE_URL"
	else
		showLines "*"
		echo "SUMMARY (darksun-$TOOL_VERSION)"
		showLines "-"
		echo "Device name: $MODEL"
		echo "Version: $VERSION"
		echo "Build: $BUILD_NUMBER"
		echo "Internal build name: $BUILD_NAME"
		if [[ ! -z "$DOCUMENTATION_NAME" ]]; then
			echo "Public build name: $DOCUMENTATION_NAME"
		fi
		if [[ "$SEARCH_DELTA_UPDATE" == YES ]]; then
			echo "Prerequisite: $PREREQUISITE_BUILD"
			echo "Update type: Short"
		else
			echo "Update type: Full"
		fi
		if [[ "$OTA_PROFILE" == CUSTOM || "$OTA_PROFILE" == MOBILE_CONFIG ]]; then
			echo "Update Asset: $FINAL_OTA_URL"
		fi
		echo "Update URL: $DOWNLOAD_FIRMWARE_URL"
		if [[ ! -z "$DOWNLOAD_DOCUMENTATION_URL" ]]; then
			echo "Documentation URL: $DOWNLOAD_DOCUMENTATION_URL"
		fi
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
	echo "Downloading OTApack for extracting update file... (http://newosxbook.com/articles/OTA3.html)"
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
			curl -k -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_FIRMWARE_URL"
		else
			curl -k -# -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_FIRMWARE_URL"
		fi
	else
		if [[ "$VERBOSE" == YES ]]; then
			curl -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_FIRMWARE_URL"
		else
			curl -# -o "$PROJECT_DIR/update.zip" "$DOWNLOAD_FIRMWARE_URL"
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
	for FILE in added replace patches; do
		if [[ -d "$PROJECT_DIR/update/AssetData/payload/$FILE" || -f "$PROJECT_DIR/update/AssetData/payload/$FILE" ]]; then
			if [[ -d "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE" || -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE" ]]; then
				rm -rf "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
				echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
			fi
			mv "$PROJECT_DIR/update/AssetData/payload/$FILE" "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-$FILE"
		fi
	done
	for FILE in app_patches links.txt patches payload removed.txt; do
		if [[ -d "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" || -f "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" ]]; then
			if [[ -d "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-$FILE" || -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-$FILE" ]]; then
				rm -rf "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-$FILE"
				echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-$FILE"
			fi
			mv "$PROJECT_DIR/update/AssetData/payloadv2/$FILE" "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-$FILE"
		fi
	done
	if [[ -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-payload" ]]; then
		for FILE in "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system"; do
			if [[ -d "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system" || -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system" ]]; then
				rm -rf "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system"
				echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system"
			fi
		done
		mkdir "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system"
		if [[ "$VERBOSE" == YES ]]; then
			"$PROJECT_DIR/OTApack/pbzx" < "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-payload" > "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb.xz"
			xz --decompress "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb.xz"
		else
			if [[ -f "$PROJECT_DIR/script" ]]; then
				rm "$PROJECT_DIR/script"
			fi
			echo "\"$PROJECT_DIR/OTApack/pbzx\" < \"$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-payload\" > \"$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb.xz\"" >> "$PROJECT_DIR/script"
			chmod +x "$PROJECT_DIR/script"
			"$PROJECT_DIR/script" > /dev/null 2>&1
			xz --decompress "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb.xz" > /dev/null 2>&1
		fi
		cd "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-system"
		if [[ "$VERBOSE" == YES ]]; then
			"$PROJECT_DIR/OTApack/otaa" -e '*' "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb"
		else
			"$PROJECT_DIR/OTApack/otaa" -e '*' "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb" > /dev/null 2>&1
		fi
		rm "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-payload"
		rm "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-pb"
	fi
	if [[ -d "$PROJECT_DIR/documentation" ]]; then
		if [[ -d "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-documentation" || -f "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-documentation" ]]; then
			rm -rf "$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-documentation"
			echo "*** CAUTION: Removed $OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-v2-documentation"
		fi
		mv "$PROJECT_DIR/documentation" "$OUTPUT_DIRECTORY/$MODEL-$VERSION-$BUILD_NUMBER-$BUILD_NAME-documentation"
	fi
	echo "Script was done."
	quitTool 0
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

function showPA2C(){
	read -s -n 1 -p "Press any key to continue..."
	echo
}

function showTitleBar(){
	if [[ -f "$PROJECT_DIR/TitleBar/$TITLE_NUM" ]]; then
		cat "$PROJECT_DIR/TitleBar/$TITLE_NUM"
	else
		echo "Title"
	fi
}

function addTitleBar(){
	if [[ ! -z "$1" ]]; then
		if [[ -z "$(ls "$PROJECT_DIR/TitleBar")" ]]; then
			echo "$1" >> "$PROJECT_DIR/TitleBar/${TITLE_NUM}"
		else
			echo "$(showTitleBar) > ${1}" >> "$PROJECT_DIR/TitleBar/$((${TITLE_NUM}+1))"
			TITLE_NUM=$((${TITLE_NUM}+1))
		fi
	fi
}

function backTitleBar(){
	if [[ -f "$PROJECT_DIR/TitleBar/${TITLE_NUM}" ]]; then
		rm "$PROJECT_DIR/TitleBar/${TITLE_NUM}"
	fi
	TITLE_NUM=$((${TITLE_NUM}-1))
}

function quitTool(){
	if [[ "$1" == 0 && ! "$DO_NOT_CLEAN_TEMP_DIR" == YES ]]; then
		if [[ -d "$PROJECT_DIR" && ! -z "$PROJECT_DIR" ]]; then
			rm -rf "$PROJECT_DIR"
		fi
	fi
	exit "$1"
}

#######################################

setOption "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
setProjectPath
if [[ "$INTERFACE_MODE" == YES ]]; then
	showInterface
fi
searchDownloadURL
showSummary
downloadBinary
downloadUpdate
extractUpdate
