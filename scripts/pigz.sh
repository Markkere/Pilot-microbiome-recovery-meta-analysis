#======PBS job script ======#
#!/bin/bash
#PBS -N pigz_left_job
#PBS -l select=1:ncpus=12:mem=300G
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR 
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate pigz

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/raw_reads"
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/reads_id/left_gz_id.txt"


while IFS= read -r line;do
    file=$(echo "$line" | sed -e 's/\r//g')
    pigz -p 8 "$input_dir/$file_"*.fastq
done < "$reads_dir"