#======PBS job script ======#
#!/bin/bash
#PBS -N human_decontamination_job
#PBS -l select=1:ncpus=12:mem=200G
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate samtools

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/bwa_output" # bwa output
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/sam_to_bam_output" # bam file output
output_decontaminated_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/Acute_paper/human_decontamination_output" #decontamination fastq output
reads_dir="/scratch/users/nus/e1694662/recovery_proj/projects/Acute_paper/reads_id/Acute_paper_reads_id.txt" #reads ID for running

cleaned_file="clean_file.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 12 "
    samtools view -bS $input_dir/{}.sam | samtools sort -o $output_dir/{}_sorted.bam
    
    samtools index $output_dir/{}_sorted.bam
    
    samtools view -b -f 12 $output_dir/{}_sorted.bam > $output_dir/{}_unmapped.bam

    samtools fastq -1 $output_decontaminated_dir/{}_trimmed_decon_R1.fastq \
                   -2 $output_decontaminated_dir/{}_trimmed_decon_R2.fastq \
                   -n $output_dir/{}_unmapped.bam" < "$cleaned_file"


