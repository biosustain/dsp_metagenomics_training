<br>

**Organisation:** Data Science Platform  
**Responsibles:** Albert Pallejà Caro (<apca@dtu.dk>)<br>Alexander Zubov
(<alzub@dtu.dk>)<br>Edir Sebastian Vidal Casto
(<s243564@student.dtu.dk>)<br>Juliana Assis (<jasge@dtu.dk>)

<br>

<!-- ----------------------- Do not edit above this ----------------------- -->

# Group comparison tutorial

This markdown is to perform a group comparison of the species abundance
among the three areas studied in the dataset.

# R Packages that need to be installed

    library(ggplot2)
    library(dplyr)
    library(tidyr)
    library(RColorBrewer)
    library(FSA)

# Load data objects

**Load species abundance, taxonomical annotation and metadata file**

    # Abundance table
    abundance <- readRDS(file = "../data/MetaphlanAbundance_Species.rds")
    rownames(abundance) <- gsub("_SRR_db1.metaphlan", "", rownames(abundance))

    # Taxonomical annotation
    annotation <- readRDS(file = "../data/MetaphlanAnnotations_Species.rds")

    # Metadata
    metadata <- read.table(file = "../data/metadata.tsv",
                           header = TRUE, sep = "\t",
                           quote = "",
                           row.names = NULL)
    rownames(metadata) <- metadata$Sample

    # Take only samples with sequencing and metadata information
    abundance <- abundance[rownames(metadata),]

## Creating a directory for the related results

    results_dir <- "../results/report/04_Group-comparison"

    dir.create(results_dir, recursive = TRUE, showWarnings = FALSE)

# Areas comparison

As there are three areas, we will use a non-parametric test (not
assuming any distribution) for three groups: Kruskal-Wallis test. We
need to run this test for all species comparing among Areas (1, 2, 3),
therefore we need to code a loop to run the test for all species and
later we need to correct for multiple testing (Bonferroni-Hochberg). For
the significant ones we will run a pot-hoc dunnTest to figure out
between which groups the differences exist.

## 🧪 Kruskal-Wallis Test

The Kruskal-Wallis test is a non-parametric method used to determine if
there are statistically significant differences in the abundance of taxa
across different groups (e.g. treatments, timepoints, compartments).

------------------------------------------------------------------------

**🔗 Step 0: Merge Abundance Data with Metadata**

Before performing the test, make sure your **abundance table** and
**metadata** are merged appropriately so each sample has its associated
group information.

------------------------------------------------------------------------

**🔍 Step 1: Prevalence Filtering**

Microbiome abundance tables are often sparse. To reduce noise from rare
taxa (e.g., species found in only one or two samples), we apply a
**prevalence filter**.

We will **keep only taxa that are present (non-zero abundance) in at
least 20% of the samples**.

**Step 2: Kruskal–Wallis test for each taxon**

-   An elegant way to run loops in R is using one of its “apply”
    functions

<!-- -->

    abundance_df <- as.data.frame(cbind(abundance,
                                        Area = metadata$Area,
                                        Sample = metadata$Sample))

    taxa_cols <- setdiff(colnames(abundance_df), 
                         c("Sample", 
                           "Area"))

    n_samples <- nrow(abundance_df)

    min_prevalence <- 0.20 * n_samples


    abundance_taxa_only <- abundance_df[, taxa_cols]

    prevalent_taxa <- sapply(abundance_taxa_only[, taxa_cols],
                             function(x) sum(x > 0)) >= min_prevalence

    filtered_taxa <- names(prevalent_taxa[prevalent_taxa])

<strong>❓ Question:</strong> How many species passed the filter?

    kruskal_results <- lapply(filtered_taxa, 
                              function(taxon) {
                                
      test_data <- abundance_df[, c(taxon,"Area")]
      colnames(test_data) <- c("Abundance","Area")
      kruskal <- kruskal.test(Abundance ~ Area, 
                              data = test_data)
      data.frame(
        Taxon = taxon,
        p_value = kruskal$p.value,
        statistic = kruskal$statistic
      )
    })

    kruskal_df <- do.call(rbind, 
                          kruskal_results)
    rownames(kruskal_df) <- kruskal_df$Taxon

## Multiple testing correction

Adjusting for multiple testing by Bonferroni and Hochberg method (False
Discovery rate)

**Filter significant taxa (e.g., FDR &lt; 0.05)**

    kruskal_df$adj_p_value <- p.adjust(kruskal_df$p_value, 
                                       method = "BH")

    significant_taxa <- kruskal_df %>% 
      filter(adj_p_value < 0.05)

    significant_taxa$Species_name <-
      annotation$species[match(rownames(significant_taxa),
                               rownames(annotation))]

    ## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.

<div class="datatables html-widget html-fill-item" id="htmlwidget-2ccdc0c3827cb648b1e4" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-2ccdc0c3827cb648b1e4">{"x":{"filter":"none","vertical":false,"extensions":["Buttons","Scroller"],"data":[["Tax_001","Tax_002","Tax_003","Tax_004","Tax_007","Tax_008","Tax_009","Tax_012","Tax_013","Tax_014","Tax_015","Tax_017","Tax_018","Tax_019","Tax_020","Tax_021","Tax_025","Tax_026","Tax_028","Tax_031","Tax_033","Tax_035","Tax_039","Tax_040","Tax_041","Tax_042","Tax_049","Tax_051","Tax_056","Tax_062","Tax_064","Tax_065","Tax_068","Tax_069","Tax_073","Tax_078","Tax_079","Tax_084","Tax_088","Tax_089","Tax_090","Tax_094","Tax_102","Tax_104","Tax_112","Tax_114","Tax_115","Tax_116","Tax_117","Tax_121","Tax_122","Tax_123","Tax_124","Tax_125","Tax_127","Tax_128","Tax_129","Tax_130","Tax_131","Tax_132","Tax_134","Tax_137","Tax_138","Tax_140","Tax_142","Tax_143","Tax_144","Tax_145","Tax_146","Tax_152","Tax_155","Tax_156","Tax_157","Tax_158","Tax_164","Tax_218"],[0.00236047207682683,0.001795783163180331,0.001189062956702195,0.01304238357213175,0.008625145810799633,0.02860994686363269,0.000435649609078136,0.001144008166961277,0.003783807572158446,0.008542975485177075,0.002063359727320817,0.02134974830292509,0.003541595692097822,0.0008864653218738476,0.0003145329653270274,0.002429487506696455,0.00521992069527082,0.01582695736921896,0.007602323493544669,0.003095586852365237,0.001189062956702195,0.0003145329653270274,0.001879472756266823,0.003783807572158446,0.008542975485177075,0.0005980143180049425,0.01199960728556935,0.009288280049936336,0.001795783163180331,0.008542975485177075,0.0003145329653270274,0.02142178927649674,0.01397938414848257,0.01093567337367365,0.004075319025246142,0.001255196883598468,0.008542975485177075,0.01446672905114548,0.001795783163180331,0.02125426947674803,0.00886478050265151,0.006987591100235797,0.02188774564831946,0.009934216737169781,0.006677704409770795,0.01050374010474571,0.0008864653218738476,0.0003145329653270274,0.0003145329653270274,0.01081698554012736,0.01961831489292864,0.0003145329653270274,0.001318402159440754,0.001795783163180331,0.0003145329653270274,0.02272130389980352,0.000821418682546011,0.008542975485177075,0.001570984057125606,0.002479855560657353,0.003771771236374461,0.0003145329653270274,0.0003145329653270274,0.0005980143180049425,0.02272130389980352,0.009748937103648337,0.008072317673242509,0.008542975485177075,0.001795783163180331,0.0003145329653270274,0.008542975485177075,0.001795783163180331,0.008542975485177075,0.02872859648867831,0.0005980143180049425,0.008542975485177075],[12.09778729478944,12.64462809917355,13.46917942677659,8.679101899827293,9.506146821215308,7.10800165837478,15.47734457323499,13.5464344941957,11.15404896421846,9.525291828793776,12.36683937823834,7.69343065693431,11.28635578583766,14.05653710247349,16.12884333821376,12.04014989293362,10.5105461393597,8.292081260364839,9.75860271115746,11.55555555555556,13.46917942677659,16.12884333821376,12.55352798053528,11.15404896421846,9.525291828793776,14.84379172229639,8.84576271186441,9.358003766478344,12.64462809917355,9.525291828793776,16.12884333821376,7.686693368936357,8.540343190945602,9.031450094161967,11.00561249389945,13.36092567868268,9.525291828793776,8.471807628524047,12.64462809917355,7.70239497447978,9.451338199513378,9.927238805970157,7.643656716417913,9.223540489642183,10.01796200345423,9.112047769582015,14.05653710247349,16.12884333821376,16.12884333821376,9.05327529021559,7.862583431488013,16.12884333821376,13.26266952177016,12.64462809917355,16.12884333821376,7.568904593639572,14.20895522388059,9.525291828793776,12.91210613598674,11.99910992434356,11.16042112776588,16.12884333821376,16.12884333821376,14.84379172229639,7.568904593639572,9.261194029850753,9.638629283489095,9.525291828793776,12.64462809917355,16.12884333821376,9.525291828793776,12.64462809917355,9.525291828793776,7.099724517906334,14.84379172229639,9.525291828793776],[0.009481800673101644,0.008050062455635965,0.007728909218564268,0.02649234163089263,0.02038670828007186,0.04914102030958132,0.005148586289105244,0.007728909218564268,0.01261269190719482,0.02038670828007186,0.00865279885650665,0.03922299444992361,0.01261269190719482,0.006778852461388246,0.004088928549251357,0.009481800673101644,0.01655096805817577,0.03070902176117111,0.02038670828007186,0.01149789402307088,0.007728909218564268,0.004088928549251357,0.008144381943822901,0.01261269190719482,0.02038670828007186,0.005552990095760181,0.02476109439879389,0.02118379660511796,0.008050062455635965,0.02038670828007186,0.004088928549251357,0.03922299444992361,0.02795876829696515,0.02292963771899314,0.01324478683204996,0.007770266422276232,0.02038670828007186,0.02849507237346836,0.008050062455635965,0.03922299444992361,0.02057895473829815,0.02038670828007186,0.03951954075391013,0.02188895213274697,0.02038670828007186,0.02275810356028237,0.006778852461388246,0.004088928549251357,0.004088928549251357,0.02292963771899314,0.0375056020011871,0.004088928549251357,0.007790558214877182,0.008050062455635965,0.004088928549251357,0.03991580414830349,0.006778852461388246,0.02038670828007186,0.008050062455635965,0.009481800673101644,0.01261269190719482,0.004088928549251357,0.004088928549251357,0.005552990095760181,0.03991580414830349,0.02185106592197041,0.02038670828007186,0.02038670828007186,0.008050062455635965,0.004088928549251357,0.02038670828007186,0.008050062455635965,0.02038670828007186,0.04914102030958132,0.005552990095760181,0.02038670828007186],["Alterinioella nitratireducens","Erythrobacter litoralis","GGB91539 SGB134165","Salinigranum rubrum","Marinobacter sp_B9_2","Halogranum gelatinilyticum","GGB26358 SGB38443","Halobellus litoreus","Coleofasciculus chthonoplastes","GGB66348 SGB89905","Roseovarius tolerans","Salinirubrum litoreum","Ectothiorhodospiraceae bacterium_WFHF3C12","GGB63892 SGB86271","Rhodohalobacter sp_WB101","Halapricum salinum","Marinobacter persicus","Marinobacter sp_Arc7_DN_1","Haloplanus rubicundus","Halorubrum depositum","Cribrihabitans marinus","Muricauda aquimarina","Marinobacter halotolerans","Salinigranum halophilum","Halohasta SGB85995","GGB8058 SGB11996","Roseovarius nitratireducens","Phaeobacter sp_JL2872","Halohasta litorea","Halohasta sp_GSL13","Wenzhouxiangella sp_XN24","Halorubrum terrestre","Halonotius terrestris","Natronomonas sp_CBA1123","Gracilimonas sp_CAU_1638","Halorubrum salsamenti","Spiribacter sp_E85","Thiohalophilus thiocyanatoxydans","GGB98463 SGB138837","Halobellus limi","Haloglomus sp_ZY58","Aliifodinibius sp_WN023","Halogeometricum rufum","Natronomonas sp_ZY43","Haloplanus aerogenes","Halorientalis marina","Halomicroarcula rubra","Halolamina sediminis","Halobaculum saliterrae","Halapricum sp_CBA1109","Halorubrum sp_CBA1229","Natronomonas halophila","Marinobacter daqiaonensis","Halorubrum trapanicum","Halolamina rubra","Halobellus ruber","Halorubrum sp_BV1","Halostella salina","Halobellus salinus","Pseudosulfitobacter sp_AP_MA_4","Haloglomus sp_ZY41","Halolamina pelagica","Halorientalis litorea","Halolamina sp_CBA1230","Haloplanus salinus","Aliifodinibius roseus","Halorussus litoreus","Halorubrum sp_Ea1","Halolamina salifodinae","Natronomonas sp_F2_12","Pseudidiomarina salinarum","Halorubellus SGB86030","Halobaculum magnesiiphilum","Natronomonas gomsonensis","Maribius pelagius","Muricauda sp_ARW1Y1"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>Taxon<\/th>\n      <th>p_value<\/th>\n      <th>statistic<\/th>\n      <th>adj_p_value<\/th>\n      <th>Species_name<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bfrtip","buttons":["copy","csv"],"deferRender":true,"scrollX":true,"scrollY":200,"scroller":true,"caption":"Sample metadata","columnDefs":[{"className":"dt-right","targets":[1,2,3]},{"name":"Taxon","targets":0},{"name":"p_value","targets":1},{"name":"statistic","targets":2},{"name":"adj_p_value","targets":3},{"name":"Species_name","targets":4}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

## Run Dunn’s test for significant taxa

    dunn_results <- lapply(significant_taxa$Taxon, 
                           function(taxon) {
                             
      test_data <- abundance_df[, c(taxon, "Area")]
      colnames(test_data) <- c("Abundance", "Area")
      test_data$Abundance <- as.numeric(test_data$Abundance)

      # Run dunnTest only if we have >1 group with non-zero data
      tryCatch({
        dunn <- dunnTest(Abundance ~ Area, 
                         data = test_data, 
                         method = "bh")
        
        dunn_df <- dunn$res
        
        dunn_df$Taxon <- taxon
        
        return(dunn_df)
      }, error = function(e) {
        message(paste("Skipping", 
                      taxon, "due to error:", e$message))
      })
    })

    # Combine Dunn test results
    dunn_df <- do.call(rbind, dunn_results)
    dunn_df$Species_name <-
      annotation$species[match(dunn_df$Taxon,
                               rownames(annotation))]

## Let’s print the statistics results

-   Let’s save the statistics for Kruskal-Wallis test
-   ordered by adj\_p\_value and with more logical order of the columns

<!-- -->

    significant_taxa <- significant_taxa %>%
      arrange(adj_p_value) %>%
      relocate(Taxon, 
               Species_name, 
               statistic, 
               p_value, 
               adj_p_value)

    write.csv(significant_taxa,
        file = "../results/report/04_Group-comparison/01_kruskal-wallis-results.csv",
        row.names = TRUE, quote = FALSE)

    write.csv(dunn_df,
      file = "../results/report/04_Group-comparison/02_post-hoc-dunn-results.csv",
      row.names = TRUE, quote = FALSE)

# Plotting the top-20 significant species

**Get top 20 taxa from Kruskal–Wallis**

    top_taxa <- kruskal_df %>%
      arrange(adj_p_value) %>%
      slice(1:20) %>%
      pull(Taxon)

## Prepare long-format data with top taxa

    abundance_df$Sampling <- metadata$Sampling
    abundance_long <- abundance_df %>%
      select(Sample, 
             Area, 
             Sampling, 
             all_of(top_taxa)) %>%
      pivot_longer(
        cols = all_of(top_taxa),
        names_to = "Taxon",
        values_to = "Abundance"
        ) 

## Order taxa by significance and fix data-types

    abundance_long$Abundance <- as.numeric(abundance_long$Abundance)
    abundance_long$Species_name <-
      annotation$species[match(abundance_long$Taxon,
                               rownames(annotation))]

    abundance_long$Species_name <- factor(abundance_long$Species_name, 
                        levels = unique(abundance_long$Species_name))

## Plot heatmap with ggplot2

    heatmap_top20 <- ggplot(abundance_long, 
                            aes(x = Sample, 
                                y = Species_name,
                            fill = log10(Abundance+0.000001))) +
      
      geom_tile(color = "white", 
                size = 0.2) +
      
      scale_fill_viridis_c(option = "B", 
                           name = "Abundance\n(log10)") +
      
      facet_grid(. ~ Area + Sampling, 
                 scales = "free") +
      
      theme_bw() +
      
      theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid = element_blank(),
        strip.text = element_text(face = "bold"),
        axis.text.y = element_text(size = 10),
        axis.title = element_blank()
      )

    ## Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
    ## ℹ Please use `linewidth` instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.

    heatmap_top20

![](04_Group-comparison_tutorial_files/figure-markdown_strict/unnamed-chunk-12-1.png)

    # Save it as a png
    ggsave("../results/report/04_Group-comparison/04_significants_heatmap.png",
           width = 8, height = 8, dpi = 300)

# Printing all package versions (good practice to ensure reproducibility)

    ## R version 4.3.1 (2023-06-16)
    ## Platform: aarch64-apple-darwin20 (64-bit)
    ## Running under: macOS 26.3.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0
    ## 
    ## locale:
    ## [1] C.UTF-8/C.UTF-8/C.UTF-8/C/C.UTF-8/C.UTF-8
    ## 
    ## time zone: Europe/Copenhagen
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] FSA_0.10.0         RColorBrewer_1.1-3 tidyr_1.3.1        dplyr_1.1.4       
    ## [5] ggplot2_3.5.1     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] jsonlite_1.8.9    gtable_0.3.6      crayon_1.5.3      compiler_4.3.1   
    ##  [5] webshot_0.5.5     tidyselect_1.2.1  jquerylib_0.1.4   textshaping_0.4.0
    ##  [9] systemfonts_1.1.0 scales_1.3.0      yaml_2.3.10       fastmap_1.2.0    
    ## [13] R6_2.5.1          labeling_0.4.3    generics_0.1.3    knitr_1.49       
    ## [17] htmlwidgets_1.6.4 tibble_3.2.1      munsell_0.5.1     bslib_0.8.0      
    ## [21] pillar_1.9.0      rlang_1.1.4       utf8_1.2.4        DT_0.33          
    ## [25] cachem_1.1.0      xfun_0.49         sass_0.4.9        viridisLite_0.4.2
    ## [29] cli_3.6.3         withr_3.0.2       magrittr_2.0.3    crosstalk_1.2.1  
    ## [33] digest_0.6.37     grid_4.3.1        lifecycle_1.0.4   vctrs_0.6.5      
    ## [37] evaluate_1.0.1    glue_1.8.0        farver_2.1.2      ragg_1.3.3       
    ## [41] dunn.test_1.3.6   fansi_1.0.6       colorspace_2.1-1  rmarkdown_2.29   
    ## [45] purrr_1.0.4       tools_4.3.1       pkgconfig_2.0.3   htmltools_0.5.8.1

<!-- --------------------- Do not edit this and below ---------------------- -->

</br>

<footer class="footer">
<div class="footer-container">
<div class="row">

<hr>

<p class="small" style="color:#bdbdbd;">
<b>2026</b> • [Data Science
Platform](https://bright.dtu.dk/technologies/biofoundry/informatics) •
[BRIGHT](https://bright.dtu.dk/)
</p>

<p style="color:#bdbdbd;">
<span class="footericon" style="padding-right:4px; padding-left:4px">
<a href="https://www.biosustain.dtu.dk/technologies/biofoundry/informatics"></a>
</span> <span class="footericon"
style="padding-right:4px; padding-left:4px">
<a href="https://x.com/dtubiosustain"></a> </span>
<span class="footericon" style="padding-left:4px">
<a href="https://www.linkedin.com/company/brightdtu/"></a> </span>
</p>

</div>
</div>
</footer>
