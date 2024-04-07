#!/bin/bash
. /root/env.sh


###
# Minecraft Server のアップデート
###

echo "Begin update Minecraft Server."

ROOT_DIR="./${MC_SERVER_ROOT_DIR}/"
SERVER_DIR="${ROOT_DIR%/}/${MC_SERVER_DIR}/"
VERSION_FILE="${ROOT_DIR%/}/version.txt"
CURRENT_VERSION=$(cat $VERSION_FILE)
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

URL=$(curl -L -A "$USER_AGENT" \
    -H "Accept-Encoding: identity" \
    -H "Accept-Language: ja" \
    https://minecraft.net/ja-jp/download/server/bedrock/ 2>/dev/null \
| grep \/bin-linux\/ \
| sed -E 's/.*<a href="(https:.*\/bin-linux\/.*\.zip).*/\1/')
FILENAME=${URL##*/}
VERSION=$(echo $FILENAME | sed -E 's/bedrock-server-(.*)\.zip/\1/')

if [ -z "$CURRENT_VERSION" ]; then
CURRENT_VERSION="prev_version"
fi

if [ "$CURRENT_VERSION" = "$VERSION" ]; then
    echo "already $CURRENT_VERSION version."
else
    if [ -d "$SERVER_DIR" ]; then
        echo "backup server: ${ROOT_DIR}${CURRENT_VERSION}"
        cp -R "$SERVER_DIR" "${ROOT_DIR}${CURRENT_VERSION}"
    fi

    echo "download file: $URL"
    wget -q -P ${ROOT_DIR}/ ${URL}

    echo "extract file: ${ROOT_DIR}${FILENAME} ==> ${SERVER_DIR}"
    unzip -o -d ${SERVER_DIR} ${ROOT_DIR}${FILENAME} 2>&1 > /dev/null

    echo "override config files."
    cp ${ROOT_DIR}${CURRENT_VERSION}/server.properties ${SERVER_DIR%/}/server.properties
    cp ${ROOT_DIR}${CURRENT_VERSION}/permissions.json ${SERVER_DIR%/}/permissions.json
    cp ${ROOT_DIR}${CURRENT_VERSION}/allowlist.json ${SERVER_DIR%/}/allowlist.json

    echo "New Version! : ${VERSION}"
    echo $VERSION > $VERSION_FILE
fi

echo "Complete update Minecraft Server."

###
# Bedrock Connect のアップデート
###

echo "Begin update Bedrock Connect."

ROOT_DIR="./${MC_CONNECT_SERVER_ROOT_DIR}/"
VERSION_FILE="${ROOT_DIR%/}/version.txt"
CURRENT_VERSION=$(cat $VERSION_FILE)

URL=$(curl -s https://api.github.com/repos/Pugmatt/BedrockConnect/releases/latest \
| jq -r '.assets[].browser_download_url' \
| grep BedrockConnect-1.0-SNAPSHOT.jar)
FILENAME=${URL##*/}
VERSION=$(echo $URL | sed -E 's|.*releases/download/([0-9\.]+)/.*|\1|')

if [ "$CURRENT_VERSION" = "$VERSION" ]; then
    echo "already $CURRENT_VERSION version."
else
    if [ -f "${ROOT_DIR}${FILENAME}" ]; then
        echo "backup file: ${ROOT_DIR%/}/backup/${FILENAME}"
        mv "${ROOT_DIR}${FILENAME}" "${ROOT_DIR%/}/backup/${FILENAME}"
    fi
    echo "download file: $URL"
    wget -q -P ${ROOT_DIR}/ ${URL}

    echo "New Version! : ${VERSION}"
    echo $VERSION > $VERSION_FILE
fi

echo "Complete update  Bedrock Connect."
