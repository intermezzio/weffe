Webcam Video Effects

Stream a video to a fake webcam or add effects to your current webcam video stream.

./weffe [-a] [-r] [-s] [-h] [-p] [-S] [-i number] [-o number] [-v filename] [-w filename] [-t text] [-b text] [-f text] [-B pattern] [-z pattern]

-a
    activate the virtual webcam (requires sudo); use -o to choose a custom video stream

-r
    slowly rotate the image or video over time

-s
    skip video processing (no duplicating the video and playing it in reverse)

-h
    view this help text

-p
    print the generated webcam command before executing it (for debugging only)

-S
    when blurring the background, use a strong blur

-i number (default 0)
    input video stream number in /dev/video#; e.g. /dev/video0 for the default webcam

-o number (default 2)
    output video stream number in /dev/video#; e.g. /dev/video2 for the default video stream

-v filename
    video that you want sent to the webcam; if no video is selected, use the input video stream

-w filename
    watermark image to overlay on top of a video stream

-t text or filename
    top text or filename for meme-ifying a video stream; must also have bottom text

-b text or filename
    bottom text or filename for meme-ifying a video stream; must also have top text

-f text (default 'Arial')
    font for meme-ified text

-B pattern
    blur pattern: choose from square, rect, portrait, circle, and ellipse

-z pattern
    rotation as a function of time; not to be used with -r
    Syntax for this rotation can be found here https://ffmpeg.org/ffmpeg-all.html#Examples-136
