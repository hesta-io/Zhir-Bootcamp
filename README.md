# ZhirAI Bootcamp

<img src="https://media.tenor.com/images/d078694360d16cefb9857e9fc6e4caf6/tenor.gif" />

This repo serves as the starting point and documentation for training new models. Since tesseract has a large number of pre-trained models (`.traineddata`), we don't need to train models from scratch. We can finetune an existing model to improve its accuracy. To learn more about the options for training models read the [official documentation](https://tesseract-ocr.github.io/tessdoc/TrainingTesseract-4.00.html#introduction).

## Steps

1. Install tesseract 4.1 with the training binaries: [Linux](https://tesseract-ocr.github.io/tessdoc/Installation.html)/[Windows](https://github.com/UB-Mannheim/tesseract/wiki) (and add it to PATH in windows). **Note:** It seems like version 5-alpha [has a bug](https://github.com/tesseract-ocr/tesseract/issues/3111) and can't be used for training yet.

   ```
   sudo apt install tesseract-ocr
   sudo apt install libtesseract-dev
   ```

1. Prepare the raw data and put it in `langdata` folder.

1. Place all fonts in the `fonts` folder.

1. Run `find . -type f -print0 | xargs -0 dos2unix` in terminal to fix line endings for all files.

1. Generate ground truth: (18 hours for 13.5 million lines total)

   ```
   python3 -m pip install image
   python3 -m pip install python-bidi
   sudo chmod +x *.sh
   nohup ./1-txt2lstmf.sh ckb > 1-ckb.log &
   ```

1. Run training (At least 24 hours):

   ```
   nice --20 nohup ./2-train-layer.sh ckb > training.log &
   ```

1. Create best and fast .traineddata files from each .checkpoint file

   ```
   make traineddata MODEL_NAME=ckb
   ```

Useful scripts:

```
# See available fonts in a folder
text2image --fonts_dir path/to/fonts --list_available_fonts

# Open a log file and scroll to the end:
less +G ./1-ckb.log

# Run 1-txt2lstmf in background:
nohup ./1-txt2lstmf.sh ckb > 1-ckb.log &

# To kill a process and see system resource usage:
htop

# Run txt2lstmf scripts:
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-1 > logs/1.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-2 > logs/2.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-3 > logs/3.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-4 > logs/4.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-5 > logs/5.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-6 > logs/6.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-7 > logs/7.log &
nice --20 nohup ./1-txt2lstmf.sh ckb fonts-8/ckb-8 > logs/8.log &

# Get disk info:
df

# Get directory size:
du -sh bootcamp

# Get number of files in a directory:
find bootcamp/gt -name '01_Sarchia_Abdulkareem.200.4*' | wc -l
find bootcamp/gt -type f | wc -l
```

## Notes:

1. Make sure `langdata/ckb/ckb.fontslist.txt` has at least one font and an empty line at the end!

## Troubleshooting

1. If you had trouble pushing your changes to the repository, run `git config http.postBuffer 524288000`.

## Read more

- [Training Tesseract 4](https://tesseract-ocr.github.io/tessdoc/TrainingTesseract-4.00.html)
- [Tesseract Data Files](https://tesseract-ocr.github.io/tessdoc/Data-Files)
- [Tesstrain wiki](https://github.com/tesseract-ocr/tesstrain/wiki). Especially the article about [Arabic Handwriting](https://github.com/tesseract-ocr/tesstrain/wiki/Arabic-Handwriting).
- [Kurdish Wikipedia Dumps](https://dumps.wikimedia.org/ckbwiki)
- [Create Custom Neural Net for hand writtern digits](http://neuralnetworksanddeeplearning.com/chap1.html)
