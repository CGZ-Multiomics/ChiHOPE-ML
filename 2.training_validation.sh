#!/bin/bash
data_root_dir="./config/cgz_main_config/cg/"
output_dir="./output/"

seed_start=1
seed_end=10
seed_interval=1

endpoint_name="y.90"

# 获取指定目录下的所有子目录名
directories=$(find "$data_root_dir" -maxdepth 1 -type d)
for dir in $directories; do
    # 跳过当前目录（"."）和上级目录（".."）
    if [ "$dir" != "$data_root_dir" ] && [ "$dir" != "$data_root_dir/.." ]; then
        # echo "Directory: $dir"
        files=$(find "$dir" -type f)
        for file in $files; do
            for ((seed=$seed_start; seed<=$seed_end; seed+=$seed_interval)); do
                echo "$endpoint_name-$file-$seed"
                python training_code/run_train.py \
                    --data_config_path $file \
                    --endpoint $endpoint_name \
                    --output_dir $output_dir \
                    --seed $seed \
                    --feature_selection_dir $feature_selection_dir \
                    --return_with_mismatch

                python validation_code/run_validation.py \
                    --data_config_path $file \
                    --endpoint $endpoint_name \
                    --output_dir $output_dir \
                    --seed $seed \
                    --feature_selection_dir $feature_selection_dir \
                    --return_with_mismatch

            done
        done
    fi
done