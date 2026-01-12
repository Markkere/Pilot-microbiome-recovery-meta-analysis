#======PBS job script ======#
#!/bin/bash
#PBS -N humann_job
#PBS -l select=1:ncpus=48:mem=200G
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate humann4

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/concat_rawreads"
mpa_dir="/home/users/nus/e1694662/scratch/metaphlan_db_oct22"
index="mpa_vOct22_CHOCOPhlAnSGB_202403"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/humann4_output"
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/reads_id/Acute_paper_reads_id.txt"

cleaned_file="humann4_id_acute_new.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"

parallel -j 7 "humann \
  --input ${input_dir}/{}_concat.fastq.gz \
  --output ${output_dir}/{}_res \
  --threads 6 \
  --input-format fastq.gz \
  --metaphlan-options=\"-t rel_ab_w_read_stats --bowtie2db ${mpa_dir} -x ${index}\"" \
  < "$cleaned_file"