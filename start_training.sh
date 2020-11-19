#!/bin/bash
# original script by J Klein <jetmonk@gmail.com> - https://pastebin.com/gNLvXkiM
# based on https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00#fine-tuning-for--a-few-characters
set -e # https://stackoverflow.com/a/2871034/7003797

################################################################
# variables to set tasks performed
MakeTraining=yes
MakeEval=yes
RunTraining=yes
BuildFinalTrainedFile=yes
################################################################

# Language - copy script files to min folder
Lang=ckb
Continue_from_lang=ckb

# Number of Iterations
MaxIterations=400

# directory with training scripts - tesstrain.sh etc.
# this is not the usual place-  because they are not installed by default
tesstrain_dir=./source

# directory with the old 'best' training set
bestdata_dir=./tessdata

# downloaded directory with language data -
langdata_dir=./langdata

# fonts directory for this system
fonts_dir=./fonts

fonts_for_training="$(cat $langdata_dir/$Lang/$Lang.fontslist.txt)"

fonts_for_eval="$(cat $langdata_dir/$Lang/$Lang.fontslist.txt)"

# output directories for this run
train_output_dir=./out/trained_$Lang
eval_output_dir=./out/eval_$Lang

# the output trained data file to drop into tesseract
best_trained_data_file=$train_output_dir/$Lang-best.traineddata
fast_trained_data_file=$train_output_dir/$Lang-fast.traineddata

# fatal bug workaround for pango
#export PANGOCAIRO_BACKEND=fc 

echo "###### MAKING TRAINING DATA ######"
rm -rf $train_output_dir
mkdir $train_output_dir
 
echo "#### run tesstrain.sh ####"
  
# the EVAL handles the quotes in the font list
eval nice  $tesstrain_dir/tesstrain.sh \
   --lang $Lang \
   --linedata_only\
   --noextract_font_properties \
   --exposures "-1 0 1" \
   --fonts_dir $fonts_dir \
   --fontlist $fonts_for_training \
   --langdata_dir $langdata_dir \
   --tessdata_dir  $bestdata_dir \
   --training_text $langdata_dir/$Lang/$Lang.training_text \
   --output_dir $train_output_dir


# at this point, $train_output_dir should have $Lang.FontX.exp0.lstmf
# and $Lang.training_files.txt

# eval data
echo "###### MAKING EVAL DATA ######"
rm -rf $eval_output_dir
mkdir $eval_output_dir
  
eval nice  $tesstrain_dir/tesstrain.sh \
   --fonts_dir $fonts_dir\
   --fontlist $fonts_for_eval \
   --lang $Lang \
   --linedata_only \
   --noextract_font_properties \
   --langdata_dir $langdata_dir \
   --tessdata_dir  $bestdata_dir \
   --training_text $langdata_dir/$Lang/$Lang.eval.training_text \
   --output_dir $eval_output_dir

# at this point, $eval_output_dir should have similar files as
# $train_output_dir but for different font set

############################# rm $train_output_dir/*checkpoint*

echo "#### combine_tessdata to extract lstm model from 'tessdata_best' for $Continue_from_lang ####"
  
  combine_tessdata -u $bestdata_dir/$Continue_from_lang.traineddata \
    $bestdata_dir/$Continue_from_lang.
    
echo "#### build version string ####"
   Version_Str="$Lang:finetune`date +%Y%m%d`:from:"
   sed -e "s/^/$Version_Str/" $bestdata_dir/$Continue_from_lang.version > $train_output_dir/$Lang.new.version

echo "#### merge unicharsets to ensure all existing chars are included ####"
echo "#### merged unicharset is not used for finetuning ####"
merge_unicharsets \
   $bestdata_dir/$Continue_from_lang.lstm-unicharset \
   $train_output_dir/$Lang/$Lang.unicharset \
   $train_output_dir/$Lang.unicharset
  
echo "#### training from $bestdata_dir/$Continue_from_lang.traineddata #####"
  
nice lstmtraining \
  --continue_from  $bestdata_dir/$Continue_from_lang.lstm \
  --traineddata  $bestdata_dir/$Continue_from_lang.traineddata \
  --max_iterations $MaxIterations \
  --debug_interval -1 \
  --train_listfile $train_output_dir/$Lang.training_files.txt \
  --model_output  $train_output_dir/$Lang

echo "#### Building final trained file $best_trained_data_file ####"
echo "#### stop training                                       ####"

lstmtraining \
  --stop_training \
  --continue_from "$train_output_dir/${Lang}_checkpoint" \
  --traineddata $bestdata_dir/$Continue_from_lang.traineddata \
  --model_output $best_trained_data_file


echo "#### lstmevl with original traineddata                                       ####"
lstmeval \
  --model $bestdata_dir/$Continue_from_lang.traineddata \
  --eval_listfile $eval_output_dir/$Lang.training_files.txt
  
echo "#### lstmevl with new traineddata                                       ####"

lstmeval \
  --model $best_trained_data_file \
  --eval_listfile $eval_output_dir/$Lang.training_files.txt
  
combine_tessdata -u $best_trained_data_file $train_output_dir/$Lang.
##cat $train_output_dir/$Lang.version
NewVer=`cat $train_output_dir/$Lang.new.version`
sed  -i  -e "s/$/:$NewVer/" $train_output_dir/$Lang.version
##cat $train_output_dir/$Lang.version
combine_tessdata $train_output_dir/$Lang.
cp  $train_output_dir/$Lang.traineddata  $train_output_dir/$Lang-best.traineddata
combine_tessdata  -c $train_output_dir/$Lang.traineddata
cp  $train_output_dir/$Lang.traineddata  $train_output_dir/$Lang-fast.traineddata

# now $best_trained_data_file is substituted for installed
