#!/bin/bash

#activate conda mpa first

input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/metaphlan4_output"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/timepoints_metaphlan"
metadata_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/metadata/Sampleid_timepoint.csv"
output_mpa_tp_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/timepoints_metaphlan/merged_result"


tail -n +2 "$metadata_dir" | while IFS=',' read -r sample tp; do
    filepath="$input_dir/$sample"
    mv "${filepath}_profile.txt" "$output_dir/$tp"
done


for dir in "$output_dir";
    cd "$dir"
    name=$(basename $dir)
    merge_metaphlan_tables.py *_profile.txt > "$output_mpa_tp_dir/${name}_merged_abudance.txt"
    cd ..
done