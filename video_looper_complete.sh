# -v video.mp4
# -r (rotate)
# -s skip processing video (must have -v)
# -i 0 (default video0 input)
# -o 2 (default video2 output)
# -w watermark.png
# -t top text (meme)
# -b bottom text (meme)
# -f font (meme)
# -B blur (format)

video=false
process=true
input=0
output=2
watermark=false
toptext=false
bottomtext=false
font="Arial"
memestr=""
rotate=false
rotatestr=""
blur=false
blurtype=""
blurstr=""
nextinput=1
inputstr=""
filterstr=""
printffmpeg=false

while getopts ":hv:rsi:o:w:t:b:f:z:B:p" opt; do
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
    ;;
    t) toptext="$OPTARG"
	;;
	b) bottomtext="$OPTARG"
	;;
	f) font="$OPTARG"
	;;
    z) rotatestr="rotate=$OPTARG,"
    ;;
    h) cat help.md
        exit 0
    ;;
    B) blur=true
		blurtype=$OPTARG
	;;
	p) printffmpeg=true
	;;
    \?) echo "Invalid option -$OPTARG" >&2
		exit 0
    ;;
  esac
done

if [[ $video != false ]]
then # if streaming a video
	if [[ $process = true ]]
	then # process the video input
        ffmpeg -y -i "$video" -filter_complex "[0]split=2[fr][rv]; \
            [rv]reverse[rv];[fr][rv]concat=n=2:v=1:a=0,format=yuv420p[v]" \
            -map "[v]" -g 30 stream.mp4
    else
        \cp -r "$video" stream.mp4
    fi
    inputstr="-stream_loop -1 -re -i stream.mp4"
else # if streaming from a webcam
	inputstr="-i /dev/video$input"
fi

if [ $blur = true ]
then
	strongblur1="luma_radius=min(w\,h)/5:chroma_radius=min(min(cw\,ch)\,120):luma_power=1"
	strongblur2="luma_radius=min(w\,h)/15:chroma_radius=min(min(cw\,ch)\,120)/2:luma_power=1"
	weakblur1=$strongblur2
	weakblur2="luma_radius=min(w\,h)/25:chroma_radius=min(min(cw\,ch)\,120)/4:luma_power=1"

	case $blurtype in
		*-strong)
			blur1=$strongblur1
			blur2=$strongblur2
		;;
		*)
			blur1=$weakblur1
			blur2=$weakblur2
		;;
	esac

	case $blurtype in 
		box|box-strong)
			blurstr="[v]split=2[v2][v];[v2]boxblur=${blur1}[bg];[v] \
				crop=iw*2/3:ih*2/3:iw/6:ih/6[fg];[bg][fg]overlay=w/4:h/4[v];"
		;;
		doublebox|doublebox-strong)
			blurstr="[v]split=3[v3][v2][v];[v3]boxblur=${blur1}[bg1]; \
				[v2]crop=iw*2/3:ih*2/3:iw/6:ih/6,boxblur=${blur2}[bg2];[v] \
				crop=iw/2:ih/2:iw/4:ih/4[fg];[bg1] \
				[bg2]overlay=w/4:h/4[bg];[bg][fg]overlay=w/2:h/2[v];"
		;;
		portrait|portrait-strong)
			# adapted from https://stackoverflow.com/a/45119116/12940893
			blurstr="[v]split=3[v3][v2][v];[v2]boxblur=${blur1}[bg]; \
				[$nextinput]alphaextract[circ];[circ][v3]scale2ref[i][m]; \
				[m][i]overlay=format=auto,format=yuv420p[mask]; \
				[v][mask]alphamerge[fg];[bg][fg]overlay[v];"
			nextinput=$((nextinput+1))
			inputstr="${inputstr} -i static/small_faded_background.png"
		;;
		circle|circle-strong)
			blurstr="[v]split=3[v3][v2][v];[v2]boxblur=${blur1}[bg]; \
				[$nextinput]alphaextract[circ];[circ][v3]scale2ref[i][m]; \
				[m][i]overlay=format=auto,format=yuv420p[mask]; \
				[v][mask]alphamerge[fg];[bg][fg]overlay[v];"
			nextinput=$((nextinput+1))
			inputstr="${inputstr} -i static/medium_faded_background.png"
		;;
		ellipse|ellipse-strong)
			# adapted from https://stackoverflow.com/a/45119116/12940893
			blurstr="[v]split=3[v3][v2][v];[v2]boxblur=${blur1}[bg]; \
				[$nextinput]alphaextract[circ];[circ][v3]scale2ref[i][m]; \
				[m][i]overlay=format=auto,format=yuv420p[mask]; \
				[v][mask]alphamerge[fg];[bg][fg]overlay[v];"
			nextinput=$((nextinput+1))
			inputstr="${inputstr} -i static/large_faded_background.png"
		;;
		*) echo "Invalid blur type \"$blurtype\"" >&2
			exit 0
		;;
	esac
	filterstr="${filterstr}${blurstr}"
fi

if [[ $watermark != false ]]
then
	waterstr="[$nextinput][v]scale2ref[i][m];[m][i]overlay=format=auto[v];"
	nextinput=$((nextinput+1))
	inputstr="${inputstr} -i $watermark"
	filterstr="${filterstr}${waterstr}"
fi

if [[ -f $toptext ]] && [[ -f $bottomtext ]]
then
	topplaintext=$(more $toptext | tr '[:lower:]' '[:upper:]')
	toptextlen=$(expr length "$toptext")
	toptextfs=$((240 / ($toptextlen / 5 + 1) ))
	
	bottomplaintext=$(more $bottomtext | tr '[:lower:]' '[:upper:]')
	bottomtextlen=$(expr length "$bottomplaintext")
	bottomtextfs=$((240 / ($bottomtextlen / 5 + 1) ))
	
	memestr="[v]drawtext=font='$font': \
		textfile='$toptext': x=(w-tw)/2: y=(h-text_h)/8: reload=1: \
		fontsize=$toptextfs: fontcolor='AntiqueWhite': borderw=4, \
		drawtext=font='$font': \
		textfile='$bottomtext':x=(w-tw)/2:y=7*(h-text_h)/8: reload=1: \
		fontsize=$bottomtextfs: fontcolor='AntiqueWhite': borderw=4[v];"

	filterstr="${filterstr}${memestr}"
elif [[ $toptext != false ]] && [[ $bottomtext != false ]]
then
	toptext=$(echo $toptext | tr '[:lower:]' '[:upper:]')
	toptextlen=$(expr length "$toptext")
	toptextfs=$((240 / ($toptextlen / 5 + 1) ))
	
	bottomtext=$(echo $bottomtext | tr '[:lower:]' '[:upper:]')
	bottomtextlen=$(expr length "$bottomtext")
	bottomtextfs=$((240 / ($bottomtextlen / 5 + 1) ))
	
	memestr="[v]drawtext=font='$font': \
		text='$toptext': x=(w-tw)/2: y=(h-text_h)/8: \
		fontsize=$toptextfs: fontcolor='AntiqueWhite': borderw=4, \
		drawtext=font='$font': \
		text='$bottomtext':x=(w-tw)/2:y=7*(h-text_h)/8: \
		fontsize=$bottomtextfs: fontcolor='AntiqueWhite': borderw=4[v];"

	filterstr="${filterstr}${memestr}"
fi

if [[ $rotate != false ]]
then
	rotatestr="[v]rotate=2*PI*t/6[v];"
	filterstr="${filterstr}${rotatestr}"
fi

# remove whitespace from filter string
filterstr=$(echo "$filterstr" | sed -r 's/\s+//g')

filterstr="[0]split=1[v];${filterstr}[v]format=yuv420p[v]"
ffmpegstr="ffmpeg $inputstr \
	-filter_complex \"${filterstr}\" \
	-map "[v]" -f v4l2 \"/dev/video$output\""

# remove more whitespace
ffmpegstr=$(echo "$ffmpegstr" | sed -r 's/\s+/ /g')

if [[ $printffmpeg != false ]]
then
	echo "Generated command:"
	echo "$ffmpegstr"
fi

sh -c "$ffmpegstr"