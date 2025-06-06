# Metagenomics data processing

Here we are going to process the dataset presented in this [paper](https://www.sciencedirect.com/science/article/pii/S004896972405647X) entitled: "Metagenomic insights into the prokaryotic communities of heavy metal-contaminated hypersaline soils".

Longer explanation about the process in [here](https://biosustain.github.io/dsp_metagenomics_training/course_contents/DataProcessing_taxprofiler.html)

But for now let's get to the practical part. let's double check few things in your terminal.

We are going to use Nextflow to run a pipeline that performs taxonomical profile of our samples: [nf-core/taxprofiler](https://nf-co.re/taxprofiler/1.1.5/). [Nextflow](https://www.nextflow.io/) is a workflow system for creating scalable, portable, and reproducible workflows. To run Nextflow you need java installed in your system and Docker.

```{code-block} bash
:caption: Verify java installation:

java -version
```

```{code-block} bash
:caption: Verify Docker installation:

docker --version
```

```{code-block} bash
:caption: Verify Nextflow installation:

nextflow -v
```

Let's get some info about Nextflow and run our first pipeline.
```{code-block} bash
:caption: Nextflow current version, system and runtime:

nextflow info
nextflow run hello
```

If everything went well you have a fully functional Nextflow environment for today.

Running taxprofiler:
```{code-block} groovy
nextflow run nf-core/taxprofiler -r 1.2.3 -profile test,docker  --outdir processed_data
```

Now that is running let's study the command:
> nextflow run --> to run the pipeline
> nf-core/taxprofiler --> it is downloaded from [github repo](https://github.com/nf-core/taxprofiler/tree/1.1.5)
> -r 1.2.3 --> we are running this version
> -profile test,docker --> we are running a test here so the input data (that would be like our fastQ files), the genomes database to map reads to (Metaphlan 4.0) and the software for the different steps is downloaded from a github repository from Nextflow. We also need Docker so that each step runs in a container isolated to ensure reproducibility
> --outdir processed_data --> intermediate files and final results will be saved in processed_data

Notice that a directory called `work` is created where there are all the pipeline steps logs. In the folder `processed_data` you will find the results of each step.