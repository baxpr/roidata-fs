#!/usr/bin/env bash
#
# PDF for QA check

echo Making PDF

# Work in output directory
cd ${out_dir}

# Views of seg over subject T1 and atlas T1
z=100
fsleyes render -of subj.png \
  --scene ortho --worldLoc 24 -10 -23 --displaySpace world --xzoom $z --yzoom $z --zzoom $z \
  --layout horizontal --hideCursor --hideLabels \
  wt1 --overlayType volume \
  rois_hipp --overlayType label --lut random_big --outlineWidth 0 #--outline

fsleyes render -of atlas.png \
  --scene ortho --worldLoc 24 -10 -23 --displaySpace world --xzoom $z --yzoom $z --zzoom $z \
  --layout horizontal --hideCursor --hideLabels \
  "${FSLDIR}"/data/standard/MNI152_T1_2mm --overlayType volume \
  rois_hipp --overlayType label --lut random_big --outlineWidth 0 #--outline


# Combine into single PDF
montage \
    -mode concatenate \
    subj.png atlas.png \
    -tile 1x2 -trim -quality 100 -background black -gravity center \
    -border 20 -bordercolor black page1.png

info_string="$project $subject $session $scan"
convert \
    -size 2600x3365 xc:white \
    -gravity center \( page1.png -resize 2400x \) -composite \
    -gravity North -pointsize 48 -annotate +0+100 \
    "Hippocampus ROIs in atlas space" \
    -gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
    -gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
    makerois-hipp.pdf

