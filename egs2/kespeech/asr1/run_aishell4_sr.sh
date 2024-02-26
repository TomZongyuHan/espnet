#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

lang=sr
train_set=train_sr
valid_set=dev_sr
test_sets="dev_sr test_sr"

asr_config=conf/aishell4/train_asr_conformer5.yaml
inference_config=conf/aishell4/decode_asr_rnn.yaml
lm_config=conf/aishell4/train_lm_transformer.yaml
use_lm=false
use_wordlm=false

dumpdir=/newdisk/data/cv-corpus-9.0-2022-04-27

# token_type are char and not bpe for chineese

./asr.sh                                               \
    --lang ${lang}                                     \
    --audio_format wav                                 \
    --feats_type raw                                   \
    --ngpu 1                                           \
    --stage 11                                         \
    --stop_stage 13                                    \
    --token_type char                                  \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --dumpdir ${dumpdir}                               \
    --asr_speech_fold_length 512                       \
    --asr_text_fold_length 150                         \
    --lm_fold_length 150                               \
    --max_wav_duration 20.                             \
    --lm_train_text "data/${train_set}/text" "$@"      \
    --nlsyms_txt data/nlsyms.txt
