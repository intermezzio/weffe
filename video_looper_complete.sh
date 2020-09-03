# -v video.mp4
# -r (rotate)
# -s skip processing video (must have -v)
# -i 0 (default video0 input)
# -o 2 (default video2 output)
# -w watermark.png

video=false
process=true
input=0
output=2
watermark=false

while getopts ":v:rsi:o:w:" opt; do
  echo $opt
  case $opt in
    v) video="$OPTARG"
    ;;
    r) rotate=true
    ;;
    s) process=false
	;;
	i) input="$OPTARG"
	;;
	o) output="$OPTARG"
	;;
	w) watermark="$OPTARG"
		printf "watermark: $watermark"
	;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ $rotate = true ]] && [[ $watermark = true ]]
then
	rotatestr="rotate=2*PI*t/6,"
elif [[ $watermark = true ]]
then
	rotatestr=""
fi


if [[ $video != false ]]
then # if streaming a video
	if [[ $process = true ]]
	then # process the video input
		norm="$video"
		rev="rev-$video"
		now="$(date)"

		ffmpeg -i $norm -vf reverse $rev
		
		printf "file '%s'\nfile '%s'" "$norm" "$rev" > "$now.txt"

		ffmpeg -f concat -i "$now.txt" -c copy "$now.mp4"

		rm $rev "$now.txt"

		video="$now.mp4"
	fi

	if [[ $rotate = true ]]
	then # rotate video and stream it
		ffmpeg -stream_loop -1 -re -i "$video" -vf rotate=2*PI*t/6 -map 0:v -f v4l2 "/dev/video$output"
	else
		printf "streaming, video = $video"
		ffmpeg -stream_loop -1 -re -i "$video" -map 0:v -f v4l2 "/dev/video$output"
	fi
else # if streaming from a webcam
	if [[ $watermark != false ]]
	then
		printf "watermark me"
		ffmpeg -i "/dev/video$input" -i "$watermark" \
			-filter_complex "[1][0]scale2ref[i][m];[m][i]overlay=format=auto,$rotatestr format=yuv420p[v]" \
			-map "[v]" -f v4l2 "/dev/video$output"
	else
		printf "ha no watermark?"
		ffmpeg -i "/dev/video$input" \
			-filter_complex "$rotatestr format=yuv420p[v]" \
			-map "[v]" -f v4l2 "/dev/video$output"
	fi
fi
# ffmpeg -i $norm -c copy v1.mp4
# ffmpeg -i $rev -c copy v2.mp4

# ffmpeg -i v1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
# ffmpeg -i v2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts

# ffmpeg -i "concat:input1.ts|input2.ts" -c copy "$now.mp4"

# ffmpeg -f concat -safe 0 -i mylist.txt -c copy "$now 2.mp4"

# rm v1.mp4 v2.mp4 input1.ts input2.ts $rev

# ffmpeg -stream_loop -1 -re -i "$video.mp4" -map 0:v -f v4l2 /dev/video2

# sh rotate_video.sh "$now.mp4"
