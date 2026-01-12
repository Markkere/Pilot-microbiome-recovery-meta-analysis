#======PBS job script ======#
#!/bin/bash
#PBS -N trimmomatic_job
#PBS -l select=1:ncpus=12:mem=120G
#PBS -l walltime=3:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/miniforge3/etc/profile.d/conda.sh
conda activate trimmomatic

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/Raw_reads"
trimmomatic_dir="/home/users/nus/e1694662/trimmomatic-0.40.jar"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/trimmomatic_output"
reads_dir="/scratch/users/nus/e1694662/recovery_proj/projects/Acute_paper/reads_id/Acute_paper_reads_id.txt"

cleaned_file="clean_file.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 12 "java -jar /home/users/nus/e1694662/trimmomatic-0.40.jar PE $input_dir/{}_1.fastq $input_dir/{}_2.fastq $output_dir/{}_trimmed_foward_paired.fastq $output_dir/{}_trimmed_foward_unpaired.fastq $output_dir/{}_trimmed_reverse_paired.fastq $output_dir/{}_trimmed_reverse_unpaired.fastq ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36" < "$cleaned_file"
