#======PBS job script ======#
#!/bin/bash
#PBS -N fastp
#PBS -l select=1:ncpus=12:mem=100G
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR 
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate fastp

# Define the directory paths
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/reads_id/left_4_id.txt"
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/test"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/trimmed_reads"
output_dir_log="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/trimmed_reads/log"

cleaned_file="clean_file.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 12 "fastp -i $input_dir/{}_1.fastq.gz \
                 -I $input_dir/{}_2.fastq.gz \
                 --out1 $output_dir/{}_fastp_R1.fq.gz \
                 --out2 $output_dir/{}_fastp_R2.fq.gz \
                 -j $output_dir_log/{}_fastp.json \
                 -h $output_dir_log/{}_fastp.html \
                 2> $output_dir_log/{}_fastp.log" < "$cleaned_file"