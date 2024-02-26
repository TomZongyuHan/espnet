# split to sub-dialects or combine sub-dialects
'''
该脚本只针对phase1
Mandarin: Mandarin from phase1，口音数据集只存在于phase1
phase2全是mandarin，不用split
'''
import os
import sys

def main(dialect, root_path):
    sets=["train", "dev", "test"]
    file_type=['utt2subdialect','text','utt2spk','wav.scp']

    for set in sets:
        source_utt2subdialect_path=root_path+set+'_phase1/utt2subdialect' if set!="test" else root_path+set+'/utt2subdialect'
        with open(source_utt2subdialect_path,mode="r") as suf:
            suf_copy=suf.readlines()
            
            target_path = root_path + set + '_' + dialect + '/'
            make_dir(target_path)
            for file in file_type:
                target_file_path=target_path+file
                with open(target_file_path, mode="w") as tf:
                    backup=[line for line in suf_copy if dialect in line]
                    if file == "utt2subdialect":
                        tf.writelines(backup)
                        # tf.writelines(x for x in backup)
                    else:
                        s_type_path = root_path + set + '_phase1/' + file if set != "test" else root_path + set + '/' + file
                        with open(s_type_path, mode="r") as stypef:
                            stypef_copy = stypef.readlines()
                            backup_uttid=[j.split(' ')[0] for j in backup]
                            selected=[i for i in stypef_copy if i.split(' ')[0] in backup_uttid]
                            tf.writelines(selected)
        suf.close(),tf.close(),stypef.close()

def make_dir(path):
        try:
            os.makedirs(path)
        except:
            print('注意: {}已经存在'.format(path))

if __name__=='__main__':
    # "Mandarin","Zhongyuan","Southwestern","Ji-Lu","Jiang-Huai","Lan-Yin","Jiao-Liao","Northeastern","Beijing"
    dialect = sys.argv[1]
    root_path = sys.argv[2]
    main(dialect, root_path)