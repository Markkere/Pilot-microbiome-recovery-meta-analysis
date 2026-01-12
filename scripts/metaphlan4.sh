#======PBS job script ======#
#!/bin/bash
#PBS -N metaphlan_breif_job
#PBS -l select=1:ncpus=48:mem=200G
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate metaphlan

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/Raw_reads"
mpa_dir="/home/users/nus/e1694662/scratch/metaphlan_db_oct22"
index="mpa_vOct22_CHOCOPhlAnSGB_202403"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/result/metaphlan4/metaphlan4_raw_reads_oct"
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/reads_id/Acute_paper_reads_id.txt"
read_file_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper"
cleaned_file="metaphlan4_oct_acute.txt"
sed 's/\r$//' "$reads_dir" > "$read_file_dir/$cleaned_file"

parallel -j 7 "metaphlan $input_dir/{}_1.fastq.gz,$input_dir/{}_2.fastq.gz \
--input_type fastq \
--bowtie2db $mpa_dir \
-x $index \
--nproc 5 \
-t rel_ab_w_read_stats \
--bowtie2out $output_dir/{}_bt2_out.txt \
-o $output_dir/{}_profile.txt" < "$read_file_dir/$cleaned_file"