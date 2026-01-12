#======PBS job script ======#
#!/bin/bash
#PBS -N bowtie2
#PBS -l select=1:ncpus=18:mem=200G
#PBS -l walltime=12:00:00
#PBS -j oe
#PBS -q normal

cd $PBS_O_WORKDIR
module load miniforge3
module load parallel/20240522
source ~/scratch/miniforge3/etc/profile.d/conda.sh
conda activate bowtie2

# Define the directory paths
input_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/raw_reads" # trimmomatic output
output_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/bowtie_output" # sam fil output
reads_dir="/home/users/nus/e1694662/scratch/recovery_proj/projects/breif_paper/reads_id/left_4_id.txt" #samples id list
human_genome_ref="/home/users/nus/e1694662/scratch/human_genome_ref_bowtie2/index/CHM13_index" # reference human genome (GR38)

cleaned_file="clean_file.txt"
sed 's/\r$//' "$reads_dir" > "$cleaned_file"
parallel -j 2 "bowtie2 -x $human_genome_ref \
                -1 $input_dir/{}_1.fastq.gz \
                -2 $input_dir/{}_2.fastq.gz \
                -p 8 \
                --very-sensitive-local \
                --un-conc-gz $output_dir/{}_bt2_decontaminated_R%.fq.gz \
                -S /dev/null \
                --mm \
                2> $output_dir/{}_bt2_alignment_summary.txt" < "$cleaned_file"
