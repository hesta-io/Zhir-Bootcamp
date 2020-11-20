#!/bin/bash
# SINGLE line images using text2image - don't split file among fonts - ckb20
#  text with no numbers or punctuation 
# nohup bash -x 1-txt2lstmf.sh ckb > 1-ckb.log & 

unicodefontdir=./fonts
MODEL=$1
FONTSLIST_NAME=$2
prefix=gt/$MODEL
#rm -rf ${prefix} ${prefix}-200
mkdir -p ${prefix} ${prefix}-200

traininginput=langdata/$MODEL/$MODEL.training_text
fontlist=langdata/$MODEL/$FONTSLIST_NAME.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")

echo "Fonts: " $fontcount
echo "Lines: " $linecount

# files created by script during processing
fonttext=/tmp/$MODEL-file-train.txt
linetext=/tmp/$MODEL-line-train.txt

SCRIPTPATH=`pwd`
TESSDATA_PATH=$SCRIPTPATH/tessdata
echo 'setting TESSDATA_PREFIX to ' $TESSDATA_PATH
export TESSDATA_PREFIX=$TESSDATA_PATH

font_counter=1
while IFS= read -r fontname
     do
        line_counter=1
        cp ${traininginput} ${fonttext}
        for cnt in $(seq 1 $linecount) ; do

            remainder=$(( line_counter % 100 ))
            if [ "$remainder" -eq 0 ]; then
                head -1 ${fonttext} > ${linetext}
                sed -i  "1,1  d"  ${fonttext}
                text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"   --outputbase="$prefix"/"${fontname// /_}.300.$cnt.exp0" 
                cp "$linetext" "$prefix"/"${fontname// /_}.300.$cnt.exp0".gt.txt
                tesseract "$prefix"/"${fontname// /_}.300.$cnt.exp0".tif "$prefix"/"${fontname// /_}.300.$cnt.exp0" -l ara --psm 13 --dpi 300 lstm.train  
                text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"  --resolution=200  --outputbase=$prefix-200/"${fontname// /_}.200.$cnt.exp0" 
                cp "$linetext" $prefix-200/"${fontname// /_}.200.$cnt.exp0".gt.txt
                tesseract $prefix-200/"${fontname// /_}.200.$cnt.exp0".tif $prefix-200/"${fontname// /_}.200.$cnt.exp0" -l ara --psm 13 --dpi 200 lstm.train  

                echo "========== LINES PROCESSED:" $line_counter "of font #" $font_counter "=========="
            else
                head -1 ${fonttext} > ${linetext}
                sed -i  "1,1  d"  ${fonttext}
                text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"   --outputbase="$prefix"/"${fontname// /_}.300.$cnt.exp0" 2>/dev/null
                cp "$linetext" "$prefix"/"${fontname// /_}.300.$cnt.exp0".gt.txt
                tesseract "$prefix"/"${fontname// /_}.300.$cnt.exp0".tif "$prefix"/"${fontname// /_}.300.$cnt.exp0" -l ara --psm 13 --dpi 300 lstm.train  2>/dev/null
                text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"  --resolution=200  --outputbase=$prefix-200/"${fontname// /_}.200.$cnt.exp0" 2>/dev/null
                cp "$linetext" $prefix-200/"${fontname// /_}.200.$cnt.exp0".gt.txt
                tesseract $prefix-200/"${fontname// /_}.200.$cnt.exp0".tif $prefix-200/"${fontname// /_}.200.$cnt.exp0" -l ara --psm 13 --dpi 200 lstm.train 2>/dev/null
            fi

            line_counter=$(( line_counter + 1 ))
         done
        ls -1  $prefix/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$MODEL-lstmf
        ls -1  $prefix-200/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$MODEL-200-lstmf
        echo "Done with ${fontname// /_}"
        font_counter=$(( font_counter + 1 ))
     done < "$fontlist"
echo "All Done"





 