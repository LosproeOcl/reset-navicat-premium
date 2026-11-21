#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/navi-reset.conf"

echo "Navicat Premium reset"

# Check if Navicat is running
if pgrep -x "Navicat Premium" > /dev/null; then
    echo ""
    echo "   Navicat Premium is currently running!"
    echo "   Please save your work before continuing."
    echo ""
    read -n 1 -s -r -p "Press any key to close Navicat and continue..."
    echo ""
    echo "Closing Navicat Premium..."
    killall "Navicat Premium" 2>/dev/null
    sleep 1
fi

file=$(defaults read "$NAVICAT_APP_PATH/Contents/Info.plist")

regex="CFBundleShortVersionString = \"([^\"]+)\""
[[ $file =~ $regex ]]

full_version=${BASH_REMATCH[1]}
version=${full_version%%.*}

echo "Detected Navicat Premium version $full_version"

service="$NAVICAT_SERVICE"
case $version in
    "18"|"17"|"16")
        ;;
    "15")
        service="com.prect.NavicatPremium15"
        ;;
    *)
        echo "Version '$version' not handled"
        exit 1
        ;;
esac

echo "Reseting trial time..."

regex="([0-9A-Z]{32}) = "
hash=""
if [[ $(defaults read "$NAVICAT_PREFERENCES") =~ $regex ]]; then
    hash=${BASH_REMATCH[1]}
fi

if [ ! -z "$hash" ]; then
    echo "deleting $hash array..."
    defaults delete "$NAVICAT_PREFERENCES" "$hash"
fi

regex="\.([0-9A-Z]{32})"
hash2=""
if [[ $(ls -a "$NAVICAT_DATA_DIR") =~ $regex ]]; then
    hash2=${BASH_REMATCH[1]}
fi

if [ ! -z "$hash2" ]; then
    echo "deleting $hash2 folder..."
    rm -f "$NAVICAT_DATA_DIR/.$hash2"
fi

# Keychain cleanup only needed for v17.3.7+
needs_keychain=false
if [[ "$version" =~ ^1[7-9]$ ]]; then
    IFS='.' read -r maj min patch <<< "$full_version"
    if [[ "$version" == "18" ]] || (( min > 3 )) || (( min == 3 && patch >= 7 )); then
        needs_keychain=true
    fi
fi

if [ "$needs_keychain" = true ]; then
    # Get all keychain hashes for this service (may be multiple)
    keychain_hashes=$(security dump-keychain "$NAVICAT_KEYCHAIN" 2>/dev/null | grep -A 5 "$service" | grep acct | grep -oE '[0-9A-F]{32}' || true)

    if [ ! -z "$keychain_hashes" ]; then
        # Delete each keychain entry
        while IFS= read -r keychain_hash; do
            if [ ! -z "$keychain_hash" ]; then
                echo "deleting keychain entry $keychain_hash..."
                security delete-generic-password -s "$service" -a "$keychain_hash" &>/dev/null
            fi
        done <<< "$keychain_hashes"
    fi
fi

echo "Done"
