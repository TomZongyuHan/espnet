#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

# General Settings
# "Mandarin","Zhongyuan","Southwestern","Ji-Lu","Jiang-Huai","Lan-Yin","Jiao-Liao","Northeastern","Beijing"
lang=sr
train_set=train_sr
valid_set=dev_sr
test_sets="dev_sr test_sr"

# dump output dir
dumpdir=/newdisk/data/cv-corpus-9.0-2022-04-27
use_lm=false  # To skip stage 6-8 -- lm model related
use_wordlm=false

# Model Settings
# wav2vec Config
# 1. conformer7_wav2vec2_960hr_large
asr_config=conf/w2v2_960h/train_asr_conformer7_wav2vec2_960hr_large.yaml
pretrained_model_path=downloads/pretrained_model/libri960_big.pt

# 2. wav2vec_small
# asr_config=conf/train_asr_wav2vec2_small.yaml
# pretrained_model_path=downloads/pretrained_model/wav2vec_small.pt

# 3. wav2vec2_large_ll60k
# asr_config=conf/train_asr_wav2vec2_ll60k.yaml
# pretrained_model_path=downloads/pretrained_model/wav2vec2_large_ll60k.pt


# Branchformer Config
# asr_config=conf/train_asr_branchformer.yaml
inference_config=conf/w2v2_960h/decode_asr.yaml

nbpe=150

# token type: char for zh, bpe for others
./asr.sh \
    --nj 32                                             \
    --inference_nj 32                                   \
    --ngpu 1                                            \
    --stage 11                                           \
    --stop_stage 13                                     \
    --lang ${lang}                                      \
    --feats_type raw                                    \
    --token_type bpe                                    \
    --nbpe $nbpe                                        \
    --dumpdir ${dumpdir}                                \
    --use_lm ${use_lm}                                  \
    --use_word_lm ${use_wordlm}                         \
    --asr_config "${asr_config}"                        \
    --train_set "${train_set}"                          \
    --valid_set "${valid_set}"                          \
    --test_sets "${test_sets}"                          \
    --asr_speech_fold_length 512                        \
    --asr_text_fold_length 150                          \
    --lm_fold_length 150                                \
    --lm_train_text "data/${train_set}/text" "$@"       \
    --pretrained_model ${pretrained_model_path}         \
    --ignore_init_mismatch true                         \
    --inference_config "${inference_config}"            \


    # --audio_format "flac.ark"                           \