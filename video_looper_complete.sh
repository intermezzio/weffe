norm=$1
rev="rev-$1"
now="$(date)"
echo $norm
echo $rev

ffmpeg -i $norm -vf reverse $rev
# ffmpeg -i $rev -vf reverse $norm

printf "file '%s'\nfile '%s'" "$norm" "$rev" > "$now.txt"

ffmpeg -f concat -i "$now.txt" -c copy "$now.mp4"

rm $rev "$now.txt"

# ffmpeg -i $norm -c copy v1.mp4
# ffmpeg -i $rev -c copy v2.mp4

# ffmpeg -i v1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
# ffmpeg -i v2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts

# ffmpeg -i "concat:input1.ts|input2.ts" -c copy "$now.mp4"

# ffmpeg -f concat -safe 0 -i mylist.txt -c copy "$now 2.mp4"

# rm v1.mp4 v2.mp4 input1.ts input2.ts $rev

# ffmpeg -stream_loop -1 -re -i "$video.mp4" -map 0:v -f v4l2 /dev/video2

sh webcam_loop.sh "$now.mp4"
