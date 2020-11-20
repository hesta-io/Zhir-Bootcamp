[Install tesseract](https://tesseract-ocr.github.io/tessdoc/Installation.html):
```
sudo add-apt-repository ppa:alex-p/tesseract-ocr-devel
sudo apt-get update
```

https://github.com/tesseract-ocr/tesseract/issues/217
`fc-cache -f -v /mnt/c/Windows/Fonts/`

https://stackoverflow.com/a/62983998/7003797

`text2image --fonts_dir path/to/fonts --list_available_fonts`

`find . -type f -print0 | xargs -0 dos2unix`

2.

set unicodefontdir=/usr/share/fonts in all scripts

3.

Note: Make sure `langdata/ckb/ckb.fontslist.txt` has at least one font and an empty line at the end!

```
python3 -m pip install image
python3 -m pip install python-bidi
sudo chmod +x *.sh
./1-txt2lstmf.sh ckb
```

4.

```
 ./2-train-layer.sh ckb
```

7.

Create best and fast .traineddata files from each .checkpoint file

```
make traineddata MODEL_NAME=ckb
```

Useful scripts:

```
Open a log file and scroll to the end:

less +G ./1-ckb.log

Run 1-txt2lstmf in background:
nohup ./1-txt2lstmf.sh ckb > 1-ckb.log &

To kill a process and see system resource usage:
htop
```

