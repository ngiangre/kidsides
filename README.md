PDSdatabase
================

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
references. Final paper coming out soon!

This data resource can be used under the MIT license agreement.

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
‘openFDA\_drug\_event-parsing’ github repository (DOI:
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

We provide the [PDSportal](http://pdsportal.shinyapps.io/pdsportal/) as
an accessible web application as well as a plaatform to download our
database for the community to explore from identifying safety endpoints
in clinical trials to evaluating known and novel developmental
pharmacology.

# PDSdatabase

The `PDSdatabase` R package downloads a sqlite database to your local
machine and connects to the database using the `DBI` R package. This is
a novel data resource of half a million pediatric drug safety signals
across growth and development stages. Please see the references for
details on data fields and the [code
repository](https://github.com/ngiangre/pediatric_ade_database_study)
for the [paper](https://ssrn.com/abstract=3898786).

# Installation

``` r
#remotes::install_github("ngiangre/PDSdatabase")
library(PDSdatabase)
```

# Usage

``` r
pacman::p_load(tidyverse)

if(!("effect_peds_19q2_v0.3_20211119.sqlite" %in% list.files())){
    PDSdatabase::download_sqlite_db()
}

con <- PDSdatabase::connect_sqlite_db()

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
    ##    atc_concept_id meddra_concept_id ade       nichd gam_score  norm gam_score_se
    ##             <int>             <int> <chr>     <chr>     <dbl> <dbl>        <dbl>
    ##  1        1588648          35809076 1588648_… term…    -0.131 0             2.48
    ##  2        1588648          35809076 1588648_… infa…     0.947 0.166         1.98
    ##  3        1588648          35809076 1588648_… todd…     2.03  0.332         1.79
    ##  4        1588648          35809076 1588648_… earl…     3.11  0.499         1.86
    ##  5        1588648          35809076 1588648_… midd…     4.21  0.667         2.10
    ##  6        1588648          35809076 1588648_… earl…     5.30  0.834         2.52
    ##  7        1588648          35809076 1588648_… late…     6.38  1             3.14
    ##  8        1588648          36315755 1588648_… term…    -0.310 0             5.61
    ##  9        1588648          36315755 1588648_… infa…     2.25  0.166         4.43
    ## 10        1588648          36315755 1588648_… todd…     4.81  0.332         3.79
    ## # … with 3,225,849 more rows, and 6 more variables: gam_score_90mse <dbl>,
    ## #   gam_score_90pse <dbl>, D <int>, E <int>, DE <int>, ade_name <chr>

``` r
dplyr::tbl(con,"ade") %>% 
    dplyr::collect()
```

    ## # A tibble: 460,823 × 9
    ##    ade    atc_concept_id meddra_concept_… cluster_id gt_null_statist… gt_null_99
    ##    <chr>           <int>            <int> <chr>                 <dbl>      <dbl>
    ##  1 15886…        1588648         35809076 2                         1          0
    ##  2 15886…        1588648         36315755 2                         1          1
    ##  3 15886…        1588648         36416514 2                         1          0
    ##  4 15886…        1588648         37019318 2                         1          0
    ##  5 15886…        1588648         37019399 2                         1          1
    ##  6 15886…        1588648         37522220 2                         1          0
    ##  7 15886…        1588697         35104746 4                         0          0
    ##  8 15886…        1588697         35104812 2                         0          0
    ##  9 15886…        1588697         35104824 2                         0          0
    ## 10 15886…        1588697         35104834 4                         0          0
    ## # … with 460,813 more rows, and 3 more variables: max_score_nichd <chr>,
    ## #   cluster_name <chr>, ade_nreports <chr>

``` r
dplyr::tbl(con,"ade_raw") %>% 
    dplyr::collect()
```

    ## # A tibble: 2,326,383 × 23
    ##    safetyreportid ade               atc_concept_id meddra_concept_id nichd sex  
    ##    <chr>          <chr>                      <int>             <int> <chr> <chr>
    ##  1 10003357       21602735_36717998       21602735          36717998 midd… Male 
    ##  2 10003357       21602735_42890355       21602735          42890355 midd… Male 
    ##  3 10003357       21602735_36718024       21602735          36718024 midd… Male 
    ##  4 10003357       21603927_36717998       21603927          36717998 midd… Male 
    ##  5 10003357       21603927_42890355       21603927          42890355 midd… Male 
    ##  6 10003357       21603927_36718024       21603927          36718024 midd… Male 
    ##  7 10003388       21600449_35205038       21600449          35205038 late… Fema…
    ##  8 10003388       21600449_35205040       21600449          35205040 late… Fema…
    ##  9 10003388       21600449_35809225       21600449          35809225 late… Fema…
    ## 10 10003401       21600449_36110708       21600449          36110708 earl… Fema…
    ## # … with 2,326,373 more rows, and 17 more variables:
    ## #   reporter_qualification <chr>, receive_date <chr>, XA <dbl>, XB <dbl>,
    ## #   XC <dbl>, XD <dbl>, XG <dbl>, XH <dbl>, XJ <dbl>, XL <dbl>, XM <dbl>,
    ## #   XN <dbl>, XP <dbl>, XR <dbl>, XS <dbl>, XV <dbl>, polypharmacy <int>

``` r
disconnect_sqlite_db(con)
```

# References

Giangreco, Nicholas. Mind the developmental gap: Identifying adverse
drug effects across childhood to evaluate biological mechanisms from
growth and development. 2022. Columbia University, [PhD
dissertation](https://doi.org/10.7916/d8-5d9b-6738).

Giangreco, Nicholas P. and Tatonetti, Nicholas P., A Database of
Pediatric Drug Effects to Evaluate Ontogenic Mechanisms From Child
Growth and Development. Available at
[SSRN](https://ssrn.com/abstract=3898786) or
[DOI](http://dx.doi.org/10.2139/ssrn.3898786) or
[medRxiv](https://doi.org/10.1101/2021.07.15.21260602)
