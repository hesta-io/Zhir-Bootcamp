################################################################
# variables to set tasks performed
$MakeTraining = yes
$MakeEval = yes
$RunTraining = yes
$BuildFinalTrainedFile = yes
################################################################


# Language - copy script files to min folder
$Lang = ckb
$Continue_from_lang = Arabic


# Number of Iterations
$MaxIterations = 400

# directory with training scripts - tesstrain.sh etc.
# this is not the usual place-  because they are not installed by default
$tesstrain_dir = ./source

# directory with the old 'best' training set
$bestdata_dir = ./tessdata

# downloaded directory with language data -
$langdata_dir = ./langdata

# fonts directory for this system
$fonts_dir = ./fonts

$fonts_for_training = "$(cat $langdata_dir/$Lang/$Lang.fontslist.txt)"

$fonts_for_eval = "$(cat $langdata_dir/$Lang/$Lang.fontslist.txt)"
