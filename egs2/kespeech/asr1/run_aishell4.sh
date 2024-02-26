#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

lang=all
train_set=train_phase1
valid_set=dev_phase1
test_sets="dev_phase1 test"

asr_config=conf/aishell4/train_asr_conformer5.yaml
inference_config=conf/aishell4/decode_asr_rnn.yaml
lm_config=conf/aishell4/train_lm_transformer.yaml
use_lm=false
use_wordlm=false


# token_type are char and not bpe for chineese

./asr.sh                                               \
    --lang ${lang}                                     \
    --audio_format wav                                 \
    --feats_type raw                                   \
    --ngpu 1                                           \
    --stage 2                                          \
    --stop_stage 13                                     \
    --token_type char                                  \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${valid_set} ${test_sets}"            \
    --asr_speech_fold_length 512 \
    --asr_text_fold_length 150 \
    --lm_fold_length 150 \
    --max_wav_duration 20. \
    --lm_train_text "data/${train_set}/text" "$@" \
    --nlsyms_txt data/nlsyms.txt
