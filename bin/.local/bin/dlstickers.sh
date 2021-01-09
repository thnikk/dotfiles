#!/bin/bash

SNUMBER=$1
NAME=$2
THING=$3

[ $# -eq 0 ] && { echo "Usage: dlstickers [URL number] [pack name]"; exit 1; }

echo "Making necessary directories"
mkdir -p "$HOME/Pictures/Stickers" &>/dev/null

echo "Downloading stickers"
wget -P "$HOME/Pictures/Stickers/" "http://dl.stickershop.line.naver.jp/products/0/0/1/$SNUMBER/iphone/stickers@2x.zip"

[ -d "$HOME/Pictures/Stickers/$NAME" ] && rm -rf "$HOME/Pictures/Stickers/$NAME"

echo "Unziping sticker pack"
unzip "$HOME/Pictures/Stickers/stickers@2x.zip" -d "$HOME/Pictures/Stickers/$NAME" >/dev/null
rm "$HOME/Pictures/Stickers/stickers@2x.zip"
# Remove junk files
rm $HOME/Pictures/Stickers/$NAME/*key*.* $HOME/Pictures/Stickers/$NAME/productInfo.meta $HOME/Pictures/Stickers/$NAME/tab_off@2x.png $HOME/Pictures/Stickers/$NAME/tab_on@2x.png

echo "Resizing images for Telegram"
mogrify -geometry 512x512 $HOME/Pictures/Stickers/$NAME/*
#convert $HOME/Pictures/Stickers/$NAME/*.png -resize "512<" $HOME/Pictures/Stickers/$NAME/*.png

echo "Sticker pack is in Pictures/Stickers/${NAME}"

if [ "$THING" == "1" ] && [ "$(which telegram-cli)" ]; then

    #Cancel previous pack if applicable
    telegram-cli -W -e "msg Stickers /cancel" &&
    sleep 1
    telegram-cli -W -e "msg Stickers /newpack" &&
    sleep 1
    telegram-cli -W -e "msg Stickers ${NAME}" &&
    sleep 1

    for f in "$HOME/Pictures/Stickers/$NAME/"*.png
    do
        telegram-cli -W -e "send_document Stickers ${f}" &&
        sleep 1
        telegram-cli -W -e "msg Stickers  ⚪️"
        sleep 1
    done

    telegram-cli -W -e "msg Stickers /publish"
    sleep 1
    telegram-cli -W -e "msg Stickers /skip"
    #telegram-cli -W -e "msg Stickers $NAME"
fi
