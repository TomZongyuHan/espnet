#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
log "$0 $*"

. ./utils/parse_options.sh || exit 1;
. ./db.sh || exit 1;
. ./path.sh || exit 1;
. ./cmd.sh || exit 1;

# general configuration
SECONDS=0
stage=0
stop_stage=100

# Data preparation related
lang=$1
data_root_path=$2
train_path=${data_root_path}/train_${lang}
dev_path=${data_root_path}/dev_${lang}
test_path=${data_root_path}/test_${lang}

log "stage 1: Subdialect Split - ${lang}"
# 使用spilt_subdialect.py生成指定方言种类的kaldi-style data文件夹, 包含['utt2subdialect','text','utt2spk','wav.scp']
# eg. python3 local/spilt_subdialect.py Beijing /home/tomhzy/espnet/egs2/kespeech/data/
python3 local/spilt_subdialect.py ${lang} ${data_root_path}/

log "stage 2: spk2utt Generation"
# 使用utt2spk_to_spk2utt.pl生成spk2utt
utils/utt2spk_to_spk2utt.pl < ${train_path}/utt2spk > ${train_path}/spk2utt
utils/utt2spk_to_spk2utt.pl < ${dev_path}/utt2spk > ${dev_path}/spk2utt
utils/utt2spk_to_spk2utt.pl < ${test_path}/utt2spk > ${test_path}/spk2utt

log "Successfully finished. [elapsed=${SECONDS}s]"
