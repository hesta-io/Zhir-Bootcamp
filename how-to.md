[Install tesseract](https://tesseract-ocr.github.io/tessdoc/Installation.html):

```
sudo add-apt-repository ppa:alex-p/tesseract-ocr-devel
sudo apt-get update
sudo apt install tesseract-ocr
```

NOTE: Actually, we might need 4.1.x instead of 5! Because 5 might have a bug. See [here](https://github.com/tesseract-ocr/tesseract/issues/3111)

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
nohup ./1-txt2lstmf.sh ckb > 1-ckb.log &
```

4.

```
nohup ./2-train-layer.sh ckb > training.log &
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


nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-1 > logs/1.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-2 > logs/2.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-3 > logs/3.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-4 > logs/4.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-5 > logs/5.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-6 > logs/6.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-7 > logs/7.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-8 > logs/8.log &


Get disk info:
df

Get directory size:
du -sh bootcamp

Get number of files in a directory:
find bootcamp/gt -name '01_Sarchia_Abdulkareem.200.4*' | wc -l
find bootcamp/gt -type f | wc -l
```

```
less +G bootcamp/training.log
ls -ltr bootcamp/data/ckb/checkpoints/
grep -o 'of document' bootcamp/training.log | wc -l
```
