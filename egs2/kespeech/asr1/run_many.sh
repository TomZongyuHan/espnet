#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

# speciy gpu id
# export CUDA_VISIBLE_DEVICES=1

# Metadata dir and output dir
dumpdir=/newdisk/data/KeSpeech/Tasks/ASR
# expdir=/newdisk/espnet_outputs/kespeech_wav2vec2/FT_w2v2

# LM/ASR/decoding configuration
asr_config=conf/wav2vec2_base_dim512_lr0.0001.yaml
inference_config=conf/cv/decode_asr.yaml
lm_config=conf/cv/train_lm.yaml

# Other configures
use_lm=false
use_wordlm=false
use_ngram=false

inference_asr_model=valid.loss.ave.pth
inference_lm=valid.loss.ave.pth

# Select a language or phase1 or phase2 from "Beijing Northeastern Jiao-Liao Lan-Yin Jiang-Huai Ji-Lu Southwestern Zhongyuan phase1 phase2"
# language="Beijing Northeastern Jiao-Liao Lan-Yin Jiang-Huai Ji-Lu Southwestern Zhongyuan"
language="Beijing"

for lang in $language
do
    # dataset
    train_set=train_$lang
    valid_set=dev_$lang
    test_sets=test_$lang

    # training stage
    stage=10
    stop_stage=13

    # Data processing and training
    # stages 3~5 perfom data processing-related stuff
    # stages 6~9 perform language model-related stuff
    # stages 10~13 perform ASR-related stuff
    ./asr.sh \
        --nj 32 \
        --inference_nj 5 \
        --gpu_inference true \
        --ngpu 1 \
        --stage $stage \
        --stop_stage $stop_stage \
        --lang ${lang} \
        --audio_format "flac.ark" \
        --feats_type raw \
        --token_type char \
        --dumpdir "${dumpdir}" \
        --use_lm ${use_lm}                                 \
        --use_ngram ${use_ngram}                           \
        --use_word_lm ${use_wordlm}                        \
        --asr_config "${asr_config}"                       \
        --inference_config "${inference_config}"           \
        --lm_config "${lm_config}"                         \
        --inference_asr_model "${inference_asr_model}"     \
        --inference_lm ${inference_lm}                     \
        --train_set "${train_set}"                         \
        --valid_set "${valid_set}"                         \
        --test_sets "${valid_set} ${test_sets}"            \
        --asr_speech_fold_length 512 \
        --asr_text_fold_length 150 \
        --lm_fold_length 150 \
        --lm_train_text "data/${train_set}/text" "$@"

done



        # --expdir "${expdir}" \