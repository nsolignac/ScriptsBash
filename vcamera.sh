sudo modprobe v4l2loopback exclusive_caps=1

nohup ffmpeg -f x11grab -r 15 -s 800x600 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 &

rm nohup.out
