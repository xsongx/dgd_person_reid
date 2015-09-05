#!/usr/bin/env bash

RAW=external/raw
EXP=external/exp
CAFFE=external/caffe

cd $(dirname ${BASH_SOURCE[0]})/../

make_db () {
  ROOT_DIR=$1
  DB_DIR=$2
  if [[ $# -eq 4 ]]; then
      RESIZE_HEIGHT=$3
      RESIZE_WIDTH=$4
  else
      RESIZE_HEIGHT=160
      RESIZE_WIDTH=64
  fi

  for subset in train val test_query test_probe; do
    echo "Making ${subset} set"
    $CAFFE/build/tools/convert_imageset \
        ${ROOT_DIR}/ ${DB_DIR}/${subset}.txt ${DB_DIR}/${subset}_lmdb \
        -resize_height ${RESIZE_HEIGHT} -resize_width ${RESIZE_WIDTH}
  done

  echo "Computing images mean"
  $CAFFE/build/tools/compute_image_mean \
      ${DB_DIR}/train_lmdb ${DB_DIR}/mean.binaryproto
}


# cuhk03
python2 tools/make_lists_id_training.py \
    $EXP/datasets/cuhk03/ $EXP/db/cuhk03_split_00 --split-index 0
make_db $EXP/datasets/cuhk03 $EXP/db/cuhk03_split_00