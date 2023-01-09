KidSIDES
================

<!-- badges: start -->

[![pkgdown](https://github.com/ngiangre/kidsides/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/ngiangre/kidsides/actions/workflows/pkgdown.yaml)
[![R-CMD-check](https://github.com/ngiangre/kidsides/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ngiangre/kidsides/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/ngiangre/kidsides/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ngiangre/kidsides?branch=main)
<!-- badges: end -->

# Installation

``` r
remotes::install_github("ngiangre/kidsides")
```

# Summary

This R data package contains observation, summary, and model-level data
from pediatric drug safety research developed by Nicholas Giangreco for
his PhD dissertation in the Tatonetti lab at Columbia University.

The database is comprised of 17 tables including a table with
descriptions of the fields in each table. The main table, `ade_nichd`,
contains quantitative data from nearly 500,000 pediatric drug safety
signals across 7 child development stages spanning from birth through
late adolescence (21 years of age).

The database was created using the methods and analyses in the
references.

This data resource can be used under the [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/) license agreement.

# Usage

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(kidsides)
kidsides::download_sqlite_db()
```

    ## Attempt failed to check sqlite exists or to download from the URL: https://tlab-kidsides.s3.amazonaws.com/data/effect_peds_19q2_v0.3_20211119.sqlite.gz

``` r
con <- kidsides::connect_sqlite_db()

DBI::dbListTables(con)
```

    ##  [1] "ade"                                           
    ##  [2] "ade_nichd"                                     
    ##  [3] "ade_nichd_enrichment"                          
    ##  [4] "ade_null"                                      
    ##  [5] "ade_null_distribution"                         
    ##  [6] "ade_raw"                                       
    ##  [7] "atc_raw_map"                                   
    ##  [8] "cyp_gene_expression_substrate_risk_information"
    ##  [9] "dictionary"                                    
    ## [10] "drug"                                          
    ## [11] "drug_gene"                                     
    ## [12] "event"                                         
    ## [13] "gene"                                          
    ## [14] "gene_expression"                               
    ## [15] "grip"                                          
    ## [16] "ryan"                                          
    ## [17] "sider"

``` r
dplyr::tbl(con,"dictionary") %>% 
    dplyr::collect()
```

    ## # A tibble: 152 × 4
    ##    table field             description                                     type 
    ##    <chr> <chr>             <chr>                                           <chr>
    ##  1 drug  atc_concept_id    The ATC 5th level OMOP concept identifier.      int  
    ##  2 drug  atc_concept_name  The ATC 5th level OMOP concept name. In the ad… char…
    ##  3 drug  atc_concept_code  The ATC 5th level OMOP concept code.            char…
    ##  4 drug  ndrugreports      The number of reports of the drug in Pediatric… int  
    ##  5 drug  atc4_concept_name The ATC 4th level OMOP concept name.            char…
    ##  6 drug  atc4_concept_code The ATC 4th level OMOP concept code.            char…
    ##  7 drug  atc3_concept_name The ATC 3rd level OMOP concept name.            char…
    ##  8 drug  atc3_concept_code The ATC 3rd level OMOP concept code.            char…
    ##  9 drug  atc2_concept_name The ATC 2nd level OMOP concept name.            char…
    ## 10 drug  atc2_concept_code The ATC 2nd level OMOP concept code.            char…
    ## # … with 142 more rows

``` r
dplyr::tbl(con,"ade_nichd") %>% 
    dplyr::collect()
```

    ## # A tibble: 3,225,859 × 13
    ##    atc_c…¹ meddr…² ade   nichd gam_s…³  norm gam_s…⁴ gam_s…⁵ gam_s…⁶     D     E
    ##      <int>   <int> <chr> <chr>   <dbl> <dbl>   <dbl>   <dbl>   <dbl> <int> <int>
    ##  1 1588648  3.58e7 1588… term…  -0.131 0        2.48 -4.21      3.95     0    20
    ##  2 1588648  3.58e7 1588… infa…   0.947 0.166    1.98 -2.31      4.21     0    80
    ##  3 1588648  3.58e7 1588… todd…   2.03  0.332    1.79 -0.923     4.98     0   107
    ##  4 1588648  3.58e7 1588… earl…   3.11  0.499    1.86  0.0553    6.17     0   294
    ##  5 1588648  3.58e7 1588… midd…   4.21  0.667    2.10  0.745     7.67     0  1046
    ##  6 1588648  3.58e7 1588… earl…   5.30  0.834    2.52  1.15      9.44     1  2697
    ##  7 1588648  3.58e7 1588… late…   6.38  1        3.14  1.21     11.5      0  1729
    ##  8 1588648  3.63e7 1588… term…  -0.310 0        5.61 -9.53      8.91     0     0
    ##  9 1588648  3.63e7 1588… infa…   2.25  0.166    4.43 -5.05      9.54     0     2
    ## 10 1588648  3.63e7 1588… todd…   4.81  0.332    3.79 -1.43     11.1      0     6
    ## # … with 3,225,849 more rows, 2 more variables: DE <int>, ade_name <chr>, and
    ## #   abbreviated variable names ¹​atc_concept_id, ²​meddra_concept_id, ³​gam_score,
    ## #   ⁴​gam_score_se, ⁵​gam_score_90mse, ⁶​gam_score_90pse

``` r
dplyr::tbl(con,"ade") %>% 
    dplyr::collect()
```

    ## # A tibble: 460,823 × 9
    ##    ade           atc_c…¹ meddr…² clust…³ gt_nu…⁴ gt_nu…⁵ max_s…⁶ clust…⁷ ade_n…⁸
    ##    <chr>           <int>   <int> <chr>     <dbl>   <dbl> <chr>   <chr>   <chr>  
    ##  1 1588648_3580… 1588648  3.58e7 2             1       0 late_a… Increa… 1      
    ##  2 1588648_3631… 1588648  3.63e7 2             1       1 late_a… Increa… 1      
    ##  3 1588648_3641… 1588648  3.64e7 2             1       0 late_a… Increa… 1      
    ##  4 1588648_3701… 1588648  3.70e7 2             1       0 late_a… Increa… 1      
    ##  5 1588648_3701… 1588648  3.70e7 2             1       1 late_a… Increa… 1      
    ##  6 1588648_3752… 1588648  3.75e7 2             1       0 late_a… Increa… 1      
    ##  7 1588697_3510… 1588697  3.51e7 4             0       0 term_n… Decrea… 1      
    ##  8 1588697_3510… 1588697  3.51e7 2             0       0 late_a… Increa… 1      
    ##  9 1588697_3510… 1588697  3.51e7 2             0       0 late_a… Increa… 3      
    ## 10 1588697_3510… 1588697  3.51e7 4             0       0 term_n… Decrea… 1      
    ## # … with 460,813 more rows, and abbreviated variable names ¹​atc_concept_id,
    ## #   ²​meddra_concept_id, ³​cluster_id, ⁴​gt_null_statistic, ⁵​gt_null_99,
    ## #   ⁶​max_score_nichd, ⁷​cluster_name, ⁸​ade_nreports

``` r
dplyr::tbl(con,"ade_raw") %>% 
    dplyr::collect()
```

    ## # A tibble: 2,326,383 × 23
    ##    safetyr…¹ ade   atc_c…² meddr…³ nichd sex   repor…⁴ recei…⁵    XA    XB    XC
    ##    <chr>     <chr>   <int>   <int> <chr> <chr> <chr>   <chr>   <dbl> <dbl> <dbl>
    ##  1 10003357  2160…  2.16e7  3.67e7 midd… Male  Other … 2014-0…     0     0     0
    ##  2 10003357  2160…  2.16e7  4.29e7 midd… Male  Other … 2014-0…     0     0     0
    ##  3 10003357  2160…  2.16e7  3.67e7 midd… Male  Other … 2014-0…     0     0     0
    ##  4 10003357  2160…  2.16e7  3.67e7 midd… Male  Other … 2014-0…     0     0     0
    ##  5 10003357  2160…  2.16e7  4.29e7 midd… Male  Other … 2014-0…     0     0     0
    ##  6 10003357  2160…  2.16e7  3.67e7 midd… Male  Other … 2014-0…     0     0     0
    ##  7 10003388  2160…  2.16e7  3.52e7 late… Fema… Consum… 2014-0…     0     0     1
    ##  8 10003388  2160…  2.16e7  3.52e7 late… Fema… Consum… 2014-0…     0     0     1
    ##  9 10003388  2160…  2.16e7  3.58e7 late… Fema… Consum… 2014-0…     0     0     1
    ## 10 10003401  2160…  2.16e7  3.61e7 earl… Fema… Consum… 2014-0…     0     0     1
    ## # … with 2,326,373 more rows, 12 more variables: XD <dbl>, XG <dbl>, XH <dbl>,
    ## #   XJ <dbl>, XL <dbl>, XM <dbl>, XN <dbl>, XP <dbl>, XR <dbl>, XS <dbl>,
    ## #   XV <dbl>, polypharmacy <int>, and abbreviated variable names
    ## #   ¹​safetyreportid, ²​atc_concept_id, ³​meddra_concept_id,
    ## #   ⁴​reporter_qualification, ⁵​receive_date

``` r
kidsides::disconnect_sqlite_db(con)
```

# Background

Adverse drug reactions are a leading cause of morbidity and mortality
that costs billions of dollars for the healthcare system. In children,
there is increased risk for adverse drug reactions with potentially
lasting adverse effects into adulthood. The current pediatric drug
safety landscape, including clinical trials, is limited as it rarely
includes children and relies on extrapolation from adults. Children are
not small adults but go through an evolutionarily conserved and
physiologically dynamic process of growth and maturation. We hypothesize
that adverse drug reactions manifest from the interaction between drug
exposure and dynamic biological processes during child growth and
development.

We hypothesize that by developing statistical methodologies with prior
knowledge of dynamic, shared information during development, we can
improve the detection of adverse drug events in children. This data
package downloads the SQLite database created by applying
covariate-adjusted disproportionality generalized additive models
(dGAMs) in a systematic way to develop a resource of nearly half a
million adverse drug event (ADE) risk estimates across child development
stages.

# Pediatric Drug Safety (PDS) data

## Observation-level data

The observation-level data, case reports for drug(s) potentially linked
to adverse event(s), was collected by the Food and Drug Administration
Adverse Event System (FAERS) in the US. This data is publicly available
on the openFDA platform [here](https://open.fda.gov/data/downloads/) as
downloadable [json files](https://api.fda.gov/download.json). However,
utilizing this data as-is is non-trivial, where the drug event report
data is published in chunks as a nested json structure each quarter per
year since the 1990s. With an API key with extended permissions, I
developed custom python notebooks and scripts available in the
‘openFDA_drug_event-parsing’ github repository (DOI:
<https://doi.org/10.5281/zenodo.4464544>) to extract and format all drug
event reports prior to the third quarter of 2019. This observation-level
data used, called Pediatric FAERS, for downstream analyses is stored in
the table `ade_raw`.

## Summary-level data

The drugs and adverse events reported were coded into standard,
hierarchical vocabularies. Adverse events were standardized by the
Medical Dictionary of Regulatory Activities (MedDRA) vocabulary (details
of the hierarcy founds
[here](https://www.meddra.org/how-to-use/basics/hierarchy)). Drugs were
standardized by the Anatomical Therapeutic Class (ATC) vocabulary
(details found
[here](https://www.who.int/tools/atc-ddd-toolkit/atc-classification)).
The reporting of adverse events and drugs can be dependent on the
disease context of a report’s subject. This was represented by
summarizing the number of drugs of a therapeutic class for each report.

## Model-level data

We invented the disproportionality generalized additive model (dGAM)
method for detecting adverse drug events from these spontaneous reports.
We applied the logistic generalized additive model to all unique
drug-event pairs in Pediatric FAERS. The drug-event GAM was used to
quantify adverse event risk due to drug exposure versus no exposure
across child development stages. Please see the references for the full
specification and details on the GAM.

# PDSportal: accessible data access

We provide the [PDSportal](https://pdsportal.shinyapps.io/pdsportal/) as
an accessible web application as well as a plaatform to download our
database for the community to explore from identifying safety endpoints
in clinical trials to evaluating known and novel developmental
pharmacology.

# KidSIDES

The `kidsides` R package downloads a sqlite database to your local
machine and connects to the database using the `DBI` R package. This is
a novel data resource of half a million pediatric drug safety signals
across growth and development stages. Please see the references for
details on data fields and the [code
repository](https://github.com/ngiangre/pediatric_ade_database_study)
for the [paper](https://www.ssrn.com/abstract=3898786).

# References

Giangreco, Nicholas. Mind the developmental gap: Identifying adverse
drug effects across childhood to evaluate biological mechanisms from
growth and development. 2022. Columbia University, [PhD
dissertation](https://doi.org/10.7916/d8-5d9b-6738).

Giangreco NP, Tatonetti NP. A database of pediatric drug effects to
evaluate ontogenic mechanisms from child growth and development. Med (N
Y). 2022 Jun 20:S2666-6340(22)00232-X. [doi:
10.1016/j.medj.2022.06.001](https://doi.org/10.1016/j.medj.2022.06.001).
Epub ahead of print. PMID: 35752163.
