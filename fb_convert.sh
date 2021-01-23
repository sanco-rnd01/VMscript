#!/bin/bash
############################################################
### from RAW to PNG use:
### ffmpeg -vcodec rawvideo -f rawvideo -pix_fmt bgra -s 1280x800 -i img.raw -f image2 -vcodec png out.png
############################################################
clear
echo -ne "\e[0;34m [FFMPEG - PNG to RAW files conversion script] \e[0m\n"

if [ ! -d "./png" ]; then
  echo -ne "\e[0;31m > path to PNG files not found... exit!\e[0m\n"
  sleep 1
  exit 1
fi

#echo -ne "\e[0;33m"
PS3=' Please enter your choice: '
options=("RGB565" "BGRA" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "RGB565")
            echo -ne "\e[0;32m\n PNG files to RGB565 on <raw_rgb> folder \e[0m\n"
            mode=1
            break
            ;;
        "BGRA")
            echo -ne "\e[0;32m PNG files to BGRA on <raw_bgra> folder \e[0m\n"
            mode=2
            break
            ;;
        "Quit")
            echo -ne "\e[0;31m Abort... \e[0m\n"
            exit 0
            ;;
        *) echo -ne "\e[0;31m Invalid Option... \e[0m\n";;
    esac
done

echo -ne "\e[0;34m > Ok, proceed with conversion...\e[0m\n"
sleep 1

if [ $mode = 1 ]; then
  mkdir raw_rgb
else
  mkdir raw_bgra
fi
ls -1 ./png/*.png | cut -c7- | rev | cut -c5- | rev > files.lst
###
cat files.lst | while read line;
do
  filename=$line
  if [ $mode = 1 ]; then
  ### 16bit RGB framebuffer --------------------------------
    ffmpeg -vcodec png -i ./png/$filename.png -vcodec rawvideo -f rawvideo -pix_fmt rgb565 ./raw_rgb/$filename.raw &
    # REVERSE Action Test
    #ffmpeg -vcodec rawvideo -pix_fmt rgb565 -video_size 1280x800 -i test.raw -f image2 test.png
  else
  ### 32bit BGRA framebuffer -------------------------------
    ffmpeg -vcodec png -i ./png/$filename.png -vcodec rawvideo -f rawvideo -pix_fmt bgra ./raw_bgra/$filename.raw &
    # REVERSE Action Test
    ##ffmpeg -vcodec rawvideo -pix_fmt bgra -video_size 1280x800 -i test.raw -f image2 test.png
  fi
  wait $!
done
exit 0
#EOF
