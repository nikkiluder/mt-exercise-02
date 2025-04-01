#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data

mkdir -p $data

tools=$base/tools

# link default training data for easier access
mkdir -p $data/wikitext-2

for corpus in train valid test; do
    absolute_path=$(realpath $tools/pytorch-examples/word_language_model/data/wikitext-2/$corpus.txt)
    ln -snf $absolute_path $data/wikitext-2/$corpus.txt
done

# Create directory for Interstellar script data
mkdir -p $data/interstellar
mkdir -p $data/interstellar/raw

# Preprocess the script
cat $data/interstellar/raw/script.txt | python $base/scripts/preprocess_raw.py > $data/interstellar/raw/script.cleaned.txt

# Tokenize, fix vocabulary upper bound
cat $data/interstellar/raw/script.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 5000 --tokenize --lang "en" --sent-tokenize > \
    $data/interstellar/raw/script.preprocessed.txt

# Split into train, valid and test - adjusting splits for our dataset size
# Count total lines
total_lines=$(wc -l < $data/interstellar/raw/script.preprocessed.txt)
valid_size=150
test_size=150
train_size=$((total_lines - valid_size - test_size))

# Extract parts
head -n $valid_size $data/interstellar/raw/script.preprocessed.txt > $data/interstellar/valid.txt
tail -n $test_size $data/interstellar/raw/script.preprocessed.txt > $data/interstellar/test.txt
head -n $((valid_size + train_size)) $data/interstellar/raw/script.preprocessed.txt | tail -n $train_size > $data/interstellar/train.txt

echo "Data preparation complete. Train size: $train_size, Valid size: $valid_size, Test size: $test_size"