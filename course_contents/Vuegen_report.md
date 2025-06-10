
# Reporting with VueGen

[VueGen][vuegen-repo] is a tool that automates the creation of **reports** from bioinformatics outputs, allowing researchers with minimal coding experience to communicate their results effectively. 

With VueGen, users can produce reports by simply specifying a directory containing output files, such as plots, tables, networks, Markdown text, HTML components, and API calls, along with the report format. Supported formats include **documents** (PDF, HTML, DOCX, ODT), **presentations** (PPTX, Reveal.js), **Jupyter notebooks**, and [Streamlit][streamlit] **web applications**.

In the GitHub workspace, we will use the `base` conda environment, which you can activate
with the following command:

```bash
conda activate base
```

## Install the required packages

- [VueGen][vuegen-repo] for the report generation (developed by Henry Webel from DSP and Sebastian Ayala and Alberto Santos from MoNA at DTU Biosustain)

```bash
pip install vuegen
```

## VueGen Report

We saved some of the analyses (plots and tables) from the R markdown files in the `results/report` folder. 

You can use the following command to generate a VueGen report (Streamlit web application in this case) from them:

```bash
vuegen --directory results/report --report_type streamlit 
```

This will create the scripts to build a Streamlit web application in the `streamlit_report` folder. Now, you can run the app with the following command:

```bash
streamlit run streamlit_report/sections/report_manager.py
```

You can check additional report types supported by VueGen, and other options with the following command:

```bash
vuegen -h
```

## Further information about VueGen

If you are interested to know more about VueGen and use it for your own research projects, check out its [GitHub repository][vuegen-repo], some tutorials in YouTube
[tutorials on youtube](https://www.youtube.com/playlist?list=PLTbkQyef1c2S3qGzzva_JLlgdwsXjHCHH), and also our biorxiv [paper](https://www.biorxiv.org/content/10.1101/2025.03.05.641152v1.full.pdf).


[streamlit]: https://streamlit.io/
[vuegen-repo]: https://github.com/Multiomics-Analytics-Group/vuegen