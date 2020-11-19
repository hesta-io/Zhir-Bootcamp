# ZhirAI Bootcamp

This repo serves as the starting point and documentation for training new models. Since tesseract has a large number of pre-trained models (`.traineddata`), we don't need to train models from scratch. We can finetune an existing model to improve its accuracy. To learn more about the options for training models read the [official documentation](https://tesseract-ocr.github.io/tessdoc/TrainingTesseract-4.00.html#introduction).

## Steps

1. Install tesseract 5 with the training binaries: [Linux](https://tesseract-ocr.github.io/tessdoc/Home.html)/[Windows](https://github.com/UB-Mannheim/tesseract/wiki) (and add it to PATH in windows).

1. Prepare the raw data and put it in `langdata` folder.

1. If it's a new language, make sure you add it to all of the appropriate places in `source/language-specific.sh`.

1. Place your base model and the accompanying files in `tessdata`. Make sure its [a `best` model](https://github.com/tesseract-ocr/tessdata_best). `fast` and `legacy` models can't be finetuned. Look at the directory structure for reference. Make sure to put all of the in the same folder, don't create sub-folders.

1. Place any additional fonts in the `fonts` folder.

1. Set `$Lang` to the code of your language (e.g. ckb) in `./start_training.sh`.

1. Set `$Continue_from_lang` to the code of the language you want to base your model on (e.g. Arabic) in `./start_training.sh`.

1. Run `find . -type f -print0 | xargs -0 dos2unix` in terminal to fix line endings for all files.

1. In your terminal, run:

   ```
   ./start_training.sh
   ```

1. Wait for it to finish. Then go get your model at `out/trained_$LANG/$LANG-best.traineddata`. Where `$LANG` is your language code (e.g. ckb).

## Directory structure

```
.
|-- fonts: Contains fonts that can be used to generate ground truth.
|-- langdata: Contains raw data that that is used for training.
|   |-- ckb: Contains training data for Central Kurdish.
|   |   |-- ckb.eval.training_text: Text used to generate images for evaluation.
|   |   |-- ckb.fontslist.txt: List of fonts used to generate images. Each line must end with `\`.
|   |   |-- ckb.numbers: 🤷‍♂️.
|   |   |-- ckb.punc: 🤷‍♂️.
|   |   |-- ckb.training_text: Text used to generate images for training.
|   |   |-- ckb.training_text.bigram_freqs: Bigram frequencies (two letters) in the training text.
|   |   |-- ckb.training_text.unigram_freqs: Unigram frequencies (one letter) in the training text.
|   |   |-- ckb.wordlist: List of words and their frequencies. Sorted descending.
|   |   `-- training_files.txt: List of `.training_text` used for training.
|   |-- Arabic.unicharset: Contains the characters for Arabic script and their properties.
|   |-- Latin.unicharset: Contains the characters for Latin script and their properties.
|   |-- radical-stroke.txt: 🤷‍♂️.
|   `-- ...other language raw data goes here too.
|-- out
|   |-- eval_ckb: Evaluation output.
|   `-- trained_ckb: Training output.
|       |-- ckb.traineddata: 🤷‍♂️.
|       |-- ckb-best.traineddata: 🤷‍♂️.
|       |-- ckb-fast.traineddata: 🤷‍♂️.
|       `-- ...
|-- source: https://github.com/tesseract-ocr/tesseract/tree/master/src/training
|-- tessdata: https://github.com/tesseract-ocr/tessdata_best. But I have put all files in the same folder.
|   |-- ara.traineddata: Arabic language model.
|   |-- Arabic.lstm
|   |-- Arabic.lstm-number-dawg
|   |-- Arabic.lstm-punc-dawg
|   |-- Arabic.lstm-recoder
|   |-- Arabic.lstm-unicharset
|   |-- Arabic.lstm-word-dawg
|   |-- Arabic.traineddata
|   |-- Arabic.version
|   |-- eng.traineddata
|   `-- ...
`-- start_training.sh: This is what you use to generate `lstmf` files and then train the models.
```

## Troubleshooting

1. If you had trouble pushing your changes to the repository, run `git config http.postBuffer 524288000`.

## Read more

- [Training Tesseract 4](https://tesseract-ocr.github.io/tessdoc/TrainingTesseract-4.00.html)
- [Tesseract Data Files](https://tesseract-ocr.github.io/tessdoc/Data-Files)
- [Tesstrain wiki](https://github.com/tesseract-ocr/tesstrain/wiki). Especially the article about [Arabic Handwriting](https://github.com/tesseract-ocr/tesstrain/wiki/Arabic-Handwriting).
- [Kurdish Wikipedia Dumps](https://dumps.wikimedia.org/ckbwiki)

![Cat Soldier Saluting](https://media1.tenor.com/images/e141fe953ac021bcb8561039856edcc5/tenor.gif?itemid=7762292)
