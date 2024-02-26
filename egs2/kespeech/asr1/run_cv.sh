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

dumpdir=/newdisk/data/cv-corpus-9.0-2022-04-27

asr_config=conf/cv/train_asr_conformer5.yaml
inference_config=conf/cv/decode_asr.yaml
lm_config=conf/cv/train_lm.yaml

use_lm=false  # To skip stage 6-8 -- lm model related
use_word_lm=false

nbpe=150

# if [[ "zh" == *"${lang}"* ]]; then
#   nbpe=2500
# elif [[ "fr" == *"${lang}"* ]]; then
#   nbpe=350
# elif [[ "es" == *"${lang}"* ]]; then
#   nbpe=235
# else
#   nbpe=150
# fi

./asr.sh \
    --ngpu 1 \
    --stage 2                                          \
    --stop_stage 13                                     \
    --lang "${lang}" \
    --dumpdir ${dumpdir}                                \
    --use_lm ${use_lm}   \
    --use_word_lm ${use_word_lm} \
    --lm_config "${lm_config}" \
    --token_type bpe \
    --nbpe $nbpe \
    --feats_type raw \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${valid_set}" \
    --test_sets "${test_sets}" \
    --bpe_train_text "data/${train_set}/text" \
    --lm_train_text "data/${train_set}/text" "$@"       \

    # --speed_perturb_factors "0.9 1.0 1.1" \
