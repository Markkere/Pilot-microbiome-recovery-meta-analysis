#======PBS job script ======#
#!/bin/bash
#PBS -N prefetch_job
#PBS -l select=1:ncpus=12:mem=120G
#PBS -l walltime=10:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR 
module load miniforge3
module load parallel/20240522
export PATH=/home/users/nus/e1694662/sratoolkit.3.2.1-alma_linux64/bin:$PATH 

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/reads_id/left_raw_id.txt"
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/prefetch_reads"

cleaned_file="clean_file.txt"
sed 's/\r$//' "$input_dir" > "$cleaned_file"
parallel -j 12 "prefetch {} --max-size 1000000000000 -O $output_dir" < "$cleaned_file"



