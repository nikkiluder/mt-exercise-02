#! /bin/bash

scripts=$(dirname "$0")
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools
samples=$base/samples

mkdir -p $samples

(cd $tools/pytorch-examples/word_language_model &&
    python generate.py \
        --data $data/interstellar \
        --words 200 \
        --temperature 0.8 \
        --mps \
        --checkpoint $models/model.pt \
        --outf $samples/sample
)