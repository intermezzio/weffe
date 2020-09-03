# -v video.mp4
# -r (rotate)
# -s skip processing video (must have -v)
# -i 0 (default video0 input)
# -o 2 (default video2 output)
# -w watermark.png
# -t top text (meme)
# -b bottom text (meme)
# -f font (meme)

video=false
process=true
input=0
output=2
watermark=false
toptext=false
bottomtext=false
font="Arial"
memestr=""

while getopts ":hv:rsi:o:w:t:b:f:" opt; do
  # echo $opt
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
    t) toptext="$OPTARG"
	;;
	b) bottomtext="$OPTARG"
	;;
	f) font="$OPTARG"
	;;
    h) cat help.md
        exit 0
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ $toptext != false ]] && [[ $bottomtext != false ]]
then
	toptext=$(echo $toptext | tr '[:lower:]' '[:upper:]')
	bottomtext=$(echo $bottomtext | tr '[:lower:]' '[:upper:]')

	memestr="drawtext=font='$font': \
		text='$toptext': x=(w-tw)/2: y=(h-text_h)/8: \
		fontsize=64: borderw=4: fontcolor=AntiqueWhite, \
		drawtext=font='$font':\
		text='$bottomtext':x=(w-tw)/2:y=7*(h-text_h)/8: \
		fontsize=64: borderw=4: fontcolor=AntiqueWhite,"
fi

if [[ $rotate = true ]]
then
	rotatestr="rotate=2*PI*t/6,"
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
		ffmpeg -stream_loop -1 -re -i "$video" -vf "$memestr $rotatestr format=yuv420p[v]" -map 0:v -f v4l2 "/dev/video$output"
	else
		ffmpeg -stream_loop -1 -re -i "$video" -vf "$memestr $rotatestr format=yuv420p[v]" -map 0:v -f v4l2 "/dev/video$output"
	fi
else # if streaming from a webcam
	if [[ $watermark != false ]]
	then
		ffmpeg -i "/dev/video$input" -i "$watermark" \
			-filter_complex "[1][0]scale2ref[i][m];[m][i]overlay=format=auto,$memestr $rotatestr format=yuv420p[v]" \
			-map "[v]" -f v4l2 "/dev/video$output"
	else
		ffmpeg -i "/dev/video$input" \
			-filter_complex "$memestr $rotatestr format=yuv420p[v]" \
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
