# ffmpeg -y -i "$1" -i "$2" -filter_complex "[1][0]scale2ref[i][m];[m][i]overlay[v]" -map "[v]" -map 0:a? -ac 2 output.mp4

# ffmpeg -stream_loop -1 -re -i "$1" -map 0:v -f v4l2 /dev/video2

# ffmpeg -stream_loop -1 -re -i "$1" -i "$2" -filter_complex "[1][0]scale2ref[i][m];[m][i]overlay[v]" -map "[v]" -f v4l2 /dev/video2

# ffmpeg -re -i /dev/video0 -i "$1" -filter_complex "[1][0]scale2ref[i][m];[m][i]overlay[v]" -map "[v]" -f v4l2 /dev/video2

# ffmpeg -re -i /dev/video0 -i "$1" -pix_fmt yuv420p -filter_complex "[1][0]scale2ref[i][m];[m][i]overlay[v]" -map "[v]" -ac 2 -f v4l2 /dev/video2

ffmpeg -i /dev/video0 -i "$1" -filter_complex "[1][0]scale2ref[i][m];[m][i]overlay=format=auto,format=yuv420p[v]" -map "[v]" -f v4l2 /dev/video2