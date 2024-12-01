# AHDS Assement Code

## Project Overview
This is part of the AHDS assessment. It contains scripts, snakemake file enviroment and the final plot. Using bash and R to analysing the word frequency for our data. The pipeline will include scriots for
downloading the data, extracting the specific columns, cleaning the titles and analysing word frequency for visualisation.


## How to run the code

### Requirment
Linux
R enviroment

### We first need to check we have conda installed
	```
	source ~/initConda.sh
	```

### Set up the enviroment

1. Clone the repository:
	```
	git clone https://github.com/AmbientDeer/AHDS_summative.git 
	```
2.Make sure we go in the right directory called AHDS_summative
	```
	cd AHDS_summative
	```

3. Activate our enviroment
	```
	conda env create -f environment.yml
	conda activate AHDS
	```

### Run the programe
We use snakemake to excute the scripts in the correct order:

```
snakemake --core 1
```

We can aso run slurm.sh if we want to submit a job in BlueCrystal.

```
sbatch slurm.sh
```

We can also run the snakemake rule by rule, the method is shown below:

1. **Download Data:**
	```
	snakemake download_data --core 1
	```

2. **Process data:**
	```
	snakemake process_data --core 1
	```

3. **Clean titles:**
	```
	snakemake process_titles --core 1
	```

4. **Visualisation:**
	```
	snakemake word_frequency_trend --core 1
	```

### Directories usage
We will store our raw data in a directory called 'raw'. The cleaned data and cleaded titles data will be installed in a directory called 'clean'.
The result that will be generated from our scripts will be stored in a directory called 'plot'.
