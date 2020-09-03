Webcam Video Effects

Stream a video to a fake webcam or add effects to your current webcam video stream.

./video_looper_complete.sh [-r] [-s] [-h] [-i number] [-o number] [-v filename] [-w filename]

-r
    slowly rotate the image or video over time

-s
    skip video processing (no duplicating the video and playing it in reverse)

-h
    view this help text

-i number (default 0)
    input video stream number in /dev/video#; e.g. /dev/video0 for the default webcam

-o number (default 2)
    output video stream number in /dev/video#; e.g. /dev/video2 for the default video stream

-v filename
    video that you want sent to the webcam; if no video is selected, use the input video stream

-w filename
    watermark image to overlay on top of a video stream
