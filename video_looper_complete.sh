video="self-recording"
mkv=".mkv"
norm="$video$mkv"
rev="$video-reversed$mkv"
echo $norm
echo $rev

ffmpeg -i $norm -vf reverse $rev
# ffmpeg -i $rev -vf reverse $norm

ffmpeg -i $norm -c copy v1.mp4
ffmpeg -i $rev -c copy v2.mp4

ffmpeg -i v1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
ffmpeg -i v2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts
ffmpeg -i "concat:input1.ts|input2.ts" -c copy "$video.mp4"

now="$(date)"

mkdir "$now"
cp "$video.mp4" "$now" 

rm v1.mp4 v2.mp4 input1.ts input2.ts $rev "$video.mp4"

# ffmpeg -stream_loop -1 -re -i "$video.mp4" -map 0:v -f v4l2 /dev/video2

sh webcam_loop.sh "$now/$video.mp4"