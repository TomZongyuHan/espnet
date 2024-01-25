#!/usr/bin/env bash

# Data preparation related
lang=$1
data_root_path=$2
train_path=${data_root_path}/train_${lang}


utils/utt2spk_to_spk2utt.pl < ${train_path}/utt2spk > ${train_path}/spk2utt