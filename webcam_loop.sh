if [[ "$1" == *.txt ]]
then # list of files
	ffmpeg -stream_loop -1 -re -i "$1" -flush_packets 0:v -f v4l2 /dev/video2
else # single video
	ffmpeg -stream_loop -1 -re -i "$1" -map 0:v -f v4l2 /dev/video2
fi

# ffmpeg -re -stream_loop -1 -i list.txt -flush_packets 0 -f v4l2 /dev/video2