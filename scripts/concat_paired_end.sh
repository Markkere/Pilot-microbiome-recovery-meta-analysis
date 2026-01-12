#======PBS job script ======#
#!/bin/bash
#PBS -N concat_job
#PBS -l select=1:ncpus=12:mem=80G
#PBS -l walltime=2:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR 
module load miniforge3
module load parallel/20240522

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/Raw_reads"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/concat_rawreads"
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/reads_id/Acute_paper_reads_id.txt"

cleaned_file="concat_acute.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 12 "zcat $input_dir/{}_1.fastq.gz $input_dir/{}_2.fastq.gz | gzip > $output_dir/{}_concat.fastq.gz" < "$cleaned_file"