#======PBS job script ======#
#!/bin/bash
#PBS -N bam_left_job
#PBS -l select=1:ncpus=12:mem=200G
#PBS -l walltime=12:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate bwa

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/trimmomatic_output" # trimmomatic output
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/bwa_output" # sam fil output
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/reads_id/left_id.txt" #samples id list
human_genome_ref="/home/users/nus/e1694662/scratch/human_genome_ref/GCF_000001405.40_GRCh38.p14_genomic.fna" # reference human genome (GR38)

cleaned_file="clean_file.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 12 "bwa mem $human_genome_ref $input_dir/{}_trimmed_foward_paired.fastq $input_dir/{}_trimmed_reverse_paired.fastq > $output_dir/{}.sam" < "$cleaned_file"
