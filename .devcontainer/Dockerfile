FROM mcr.microsoft.com/devcontainers/base:noble
WORKDIR /home

RUN apt update \
    && apt -y install \
        openjdk-21-jre \
        python3-venv \
        r-base \
        r-base-dev \
        r-cran-dplyr \
        r-cran-ggplot2 \
        r-cran-ggrepel \
        r-cran-patchwork \
        r-cran-rcolorbrewer \
        r-cran-rmarkdown \
        r-cran-tidyr \
        r-cran-vegan \
    && curl -L -s -o /usr/local/bin/nextflow \
        https://github.com/nextflow-io/nextflow/releases/download/v25.04.3/nextflow-25.04.3-dist \
    && chmod +x /usr/local/bin/nextflow \
    && ln -s /usr/bin/python3 /usr/bin/python

COPY install_packages.R /tmp/install_packages.R
RUN Rscript /tmp/install_packages.R && rm /tmp/install_packages.R
