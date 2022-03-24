PDSdatabase
================

# Introduction

This data package contains the SQLite database of half a million
pediatric drug safety signals across 250,000 drug reports of children
from birth through late adolescence. The `PDSdatabase` R package
downloads a sqlite database to your local machine and connects to the
database using the `DBI` R package. This data resource can be used by
the community for research and educational purposes.

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
package contains the SQLite database created by applying
covariate-adjusted disproportionality GAMs (dGAMs) in a systematic way
to develop a resource of nearly half a million adverse drug event (ADE)
risk estimates across child development stages.

We provide the [PDSportal](http://pdsportal.shinyapps.io/pdsportal/) as
an accessible web application as well as a bulk download of our database
for the community to explore from identifying safety endpoints in
clinical trials to evaluating known and novel developmental
pharmacology.

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
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.6     ✓ dplyr   1.0.8
    ## ✓ tidyr   1.2.0     ✓ stringr 1.4.0
    ## ✓ readr   2.1.1     ✓ forcats 0.5.1

    ## Warning: package 'tidyr' was built under R version 4.0.5

    ## Warning: package 'dplyr' was built under R version 4.0.5

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
if(!("effect_peds_19q2_v0.3_20211119.sqlite" %in% list.files())){
    download_sqlite_db()
}
con <- connect_sqlite_db()
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
for(tab in DBI::dbListTables(con)){
    cat("\n\t`",tab,"` table\n\n",sep = "")
    print(dplyr::tbl(con,tab))
    cat("\n----------")
}
```

    ## 
    ##  `ade` table
    ## 
    ## # Source:   table<ade> [?? x 9]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
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
    ## # … with more rows, and 3 more variables: max_score_nichd <chr>,
    ## #   cluster_name <chr>, ade_nreports <chr>
    ## 
    ## ----------
    ##  `ade_nichd` table
    ## 
    ## # Source:   table<ade_nichd> [?? x 13]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
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
    ## # … with more rows, and 6 more variables: gam_score_90mse <dbl>,
    ## #   gam_score_90pse <dbl>, D <int>, E <int>, DE <int>, ade_name <chr>
    ## 
    ## ----------
    ##  `ade_nichd_enrichment` table
    ## 
    ## # Source:   table<ade_nichd_enrichment> [?? x 15]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    category atc_concept_name meddra_concept_name          nichd atc_concept_cla…
    ##    <chr>    <chr>            <chr>                        <chr> <chr>           
    ##  1 soc      <NA>             Blood and lymphatic system … earl… <NA>            
    ##  2 soc      <NA>             Cardiac disorders            earl… <NA>            
    ##  3 soc      <NA>             Congenital, familial and ge… earl… <NA>            
    ##  4 soc      <NA>             Ear and labyrinth disorders  earl… <NA>            
    ##  5 soc      <NA>             Endocrine disorders          earl… <NA>            
    ##  6 soc      <NA>             Eye disorders                earl… <NA>            
    ##  7 soc      <NA>             Gastrointestinal disorders   earl… <NA>            
    ##  8 soc      <NA>             General disorders and admin… earl… <NA>            
    ##  9 soc      <NA>             Hepatobiliary disorders      earl… <NA>            
    ## 10 soc      <NA>             Immune system disorders      earl… <NA>            
    ## # … with more rows, and 10 more variables: meddra_concept_class_id <chr>,
    ## #   a <int>, b <int>, c <int>, d <int>, lwr <dbl>, odds_ratio <dbl>, upr <dbl>,
    ## #   pvalue <dbl>, fdr <dbl>
    ## 
    ## ----------
    ##  `ade_null` table
    ## 
    ## # Source:   table<ade_null> [?? x 2]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##   nichd             null_99
    ##   <chr>               <dbl>
    ## 1 term_neonatal        2.65
    ## 2 infancy              2.34
    ## 3 toddler              2.38
    ## 4 early_childhood      2.70
    ## 5 middle_childhood     3.23
    ## 6 early_adolescence    3.81
    ## 7 late_adolescence     4.40
    ## 
    ## ----------
    ##  `ade_null_distribution` table
    ## 
    ## # Source:   table<ade_null_distribution> [?? x 3]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    nichd                gam_score ade              
    ##    <chr>                    <dbl> <chr>            
    ##  1 early_adolescence -0.000330    21600100_37320136
    ##  2 early_childhood   -0.000220    21600100_37320136
    ##  3 infancy           -0.000106    21600100_37320136
    ##  4 late_adolescence  -0.000384    21600100_37320136
    ##  5 middle_childhood  -0.000276    21600100_37320136
    ##  6 term_neonatal     -0.0000485   21600100_37320136
    ##  7 toddler           -0.000163    21600100_37320136
    ##  8 early_adolescence -0.00000644  21603497_36416500
    ##  9 early_childhood   -0.00000359  21603497_36416500
    ## 10 infancy           -0.000000789 21603497_36416500
    ## # … with more rows
    ## 
    ## ----------
    ##  `ade_raw` table
    ## 
    ## # Source:   table<ade_raw> [?? x 23]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
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
    ## # … with more rows, and 17 more variables: reporter_qualification <chr>,
    ## #   receive_date <chr>, XA <dbl>, XB <dbl>, XC <dbl>, XD <dbl>, XG <dbl>,
    ## #   XH <dbl>, XJ <dbl>, XL <dbl>, XM <dbl>, XN <dbl>, XP <dbl>, XR <dbl>,
    ## #   XS <dbl>, XV <dbl>, polypharmacy <int>
    ## 
    ## ----------
    ##  `atc_raw_map` table
    ## 
    ## # Source:   table<atc_raw_map> [?? x 2]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    atc1_concept_name                                               raw_code
    ##    <chr>                                                           <chr>   
    ##  1 ALIMENTARY TRACT AND METABOLISM                                 XA      
    ##  2 BLOOD AND BLOOD FORMING ORGANS                                  XB      
    ##  3 CARDIOVASCULAR SYSTEM                                           XC      
    ##  4 DERMATOLOGICALS                                                 XD      
    ##  5 GENITO URINARY SYSTEM AND SEX HORMONES                          XG      
    ##  6 SYSTEMIC HORMONAL PREPARATIONS, EXCL. SEX HORMONES AND INSULINS XH      
    ##  7 ANTIINFECTIVES FOR SYSTEMIC USE                                 XJ      
    ##  8 ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS                      XL      
    ##  9 MUSCULO-SKELETAL SYSTEM                                         XM      
    ## 10 NERVOUS SYSTEM                                                  XN      
    ## # … with more rows
    ## 
    ## ----------
    ##  `cyp_gene_expression_substrate_risk_information` table
    ## 
    ## # Source:   table<cyp_gene_expression_substrate_risk_information> [?? x 7]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    gene_symbol     type   soc       auroc wt_pvalue ttest_statistic ttest_pvalue
    ##    <chr>           <chr>  <chr>     <dbl>     <dbl>           <dbl>        <dbl>
    ##  1 CYP3A5          enzyme Eye diso… 0.217     1.00        -37.9         1   e+ 0
    ##  2 CYP3A7          enzyme Eye diso… 0.150     1.00        -39.4         1   e+ 0
    ##  3 CYP3A7-CYP3A51P enzyme Eye diso… 0.372     0.958        -9.72        1   e+ 0
    ##  4 CYP3A5          enzyme Skin and… 0.494     0.564         0.00671     4.97e- 1
    ##  5 CYP3A7          enzyme Skin and… 0.540     0.246         3.19        7.21e- 4
    ##  6 CYP3A7-CYP3A51P enzyme Skin and… 0.537     0.220         5.10        1.76e- 7
    ##  7 CYP1A1          enzyme Endocrin… 0.601     0.175         8.59        1.13e-17
    ##  8 CYP2C8          enzyme Endocrin… 0.516     0.428         0.672       2.51e- 1
    ##  9 CYP2C9          enzyme Endocrin… 0.390     0.997       -21.8         1   e+ 0
    ## 10 CYP2C18         enzyme Endocrin… 0.686     0.105        16.1         1.18e-48
    ## # … with more rows
    ## 
    ## ----------
    ##  `dictionary` table
    ## 
    ## # Source:   table<dictionary> [?? x 4]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
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
    ## # … with more rows
    ## 
    ## ----------
    ##  `drug` table
    ## 
    ## # Source:   table<drug> [?? x 12]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    atc_concept_id atc_concept_name         atc_concept_code ndrugreports
    ##             <int> <chr>                    <chr>                   <int>
    ##  1        1588648 valsartan and sacubitril C09DX04                     1
    ##  2        1588697 ivacaftor and lumacaftor R07AX30                  1142
    ##  3       21600005 sodium fluoride; oral    A01AA01                    73
    ##  4       21600008 stannous fluoride; oral  A01AA04                    66
    ##  5       21600012 hydrogen peroxide; oral  A01AB02                     9
    ##  6       21600013 chlorhexidine; oral      A01AB03                    91
    ##  7       21600019 miconazole; oral         A01AB09                    51
    ##  8       21600034 triamcinolone; oral      A01AC01                   168
    ##  9       21600056 aluminium hydroxide      A02AB01                    13
    ## 10       21600082 cimetidine; systemic     A02BA01                    84
    ## # … with more rows, and 8 more variables: atc4_concept_name <chr>,
    ## #   atc4_concept_code <chr>, atc3_concept_name <chr>, atc3_concept_code <chr>,
    ## #   atc2_concept_name <chr>, atc2_concept_code <chr>, atc1_concept_name <chr>,
    ## #   atc1_concept_code <chr>
    ## 
    ## ----------
    ##  `drug_gene` table
    ## 
    ## # Source:   table<drug_gene> [?? x 8]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    drugbank_id id        type   action    uniprot_id entrez_id gene_symbol
    ##    <chr>       <chr>     <chr>  <chr>     <chr>      <chr>     <chr>      
    ##  1 DB00001     BE0000048 target inhibitor P00734     2147      F2         
    ##  2 DB00002     BE0000767 target binder    P00533     1956      EGFR       
    ##  3 DB00002     BE0000901 target binder    O75015     2215      FCGR3B     
    ##  4 DB00002     BE0002094 target binder    P02745     712       C1QA       
    ##  5 DB00002     BE0002095 target binder    P02746     713       C1QB       
    ##  6 DB00002     BE0002096 target binder    P02747     714       C1QC       
    ##  7 DB00002     BE0002097 target binder    P08637     2214      FCGR3A     
    ##  8 DB00002     BE0000710 target binder    P12314     2209      FCGR1A     
    ##  9 DB00002     BE0002098 target binder    P12318     2212      FCGR2A     
    ## 10 DB00004     BE0000658 target binder    P01589     3559      IL2RA      
    ## # … with more rows, and 1 more variable: atc_concept_id <int>
    ## 
    ## ----------
    ##  `event` table
    ## 
    ## # Source:   table<event> [?? x 22]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    meddra_concept_name_4         meddra_concept_… neventreports meddra_concept_…
    ##    <chr>                                    <int>         <int> <chr>           
    ##  1 <NA>                                  35305812             3 <NA>            
    ##  2 <NA>                                  35808913             1 <NA>            
    ##  3 <NA>                                  36211484           272 <NA>            
    ##  4 Blood and lymphatic system d…           788149             1 PT              
    ##  5 Blood and lymphatic system d…           788161            15 PT              
    ##  6 Blood and lymphatic system d…           788294             4 PT              
    ##  7 Blood and lymphatic system d…           788327             1 PT              
    ##  8 Blood and lymphatic system d…           788452             1 PT              
    ##  9 Blood and lymphatic system d…         35104065             2 PT              
    ## 10 Blood and lymphatic system d…         35104066             7 PT              
    ## # … with more rows, and 18 more variables: meddra_concept_class_id_2 <chr>,
    ## #   meddra_concept_class_id_3 <chr>, meddra_concept_class_id_4 <chr>,
    ## #   meddra_concept_code_1 <chr>, meddra_concept_code_2 <chr>,
    ## #   meddra_concept_code_3 <chr>, meddra_concept_code_4 <chr>,
    ## #   meddra_concept_id_2 <int>, meddra_concept_id_3 <int>,
    ## #   meddra_concept_id_4 <int>, meddra_concept_name_1 <chr>,
    ## #   meddra_concept_name_2 <chr>, meddra_concept_name_3 <chr>, …
    ## 
    ## ----------
    ##  `gene` table
    ## 
    ## # Source:   table<gene> [?? x 2]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    gene_symbol probe      
    ##    <chr>       <chr>      
    ##  1 CYP2E1      1431_at    
    ##  2 CYP2A6      1494_f_at  
    ##  3 PLD1        177_at     
    ##  4 SOD1        200642_at  
    ##  5 HK1         200697_at  
    ##  6 PGK1        200737_at  
    ##  7 PGK1        200738_s_at
    ##  8 MAT2A       200768_s_at
    ##  9 MAT2A       200769_s_at
    ## 10 GSTP1       200824_at  
    ## # … with more rows
    ## 
    ## ----------
    ##  `gene_expression` table
    ## 
    ## # Source:   table<gene_expression> [?? x 10]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    sample    nichd         probe gene_symbol actual prediction residual      fdr
    ##    <chr>     <chr>         <chr> <chr>        <dbl>      <dbl>    <dbl>    <dbl>
    ##  1 GSM228562 early_adoles… 1431… CYP2E1        17.4       17.8   -0.407 1.09e-16
    ##  2 GSM228562 early_adoles… 1494… CYP2A6        54.3       54.7   -0.427 1.35e- 1
    ##  3 GSM228562 early_adoles… 177_… PLD1          60.9       43.9   16.9   5.70e- 1
    ##  4 GSM228562 early_adoles… 2006… SOD1         963.      1353.  -390.    1.19e- 1
    ##  5 GSM228562 early_adoles… 2006… HK1         1149.      1041.   108.    9.91e- 1
    ##  6 GSM228562 early_adoles… 2007… PGK1         684.       637.    47.8   1.03e- 9
    ##  7 GSM228562 early_adoles… 2007… PGK1        2131.      2120.    10.9   1.30e- 9
    ##  8 GSM228562 early_adoles… 2007… MAT2A        801.       577.   224.    2.01e- 8
    ##  9 GSM228562 early_adoles… 2007… MAT2A        121.       129.    -7.59  9.81e- 7
    ## 10 GSM228562 early_adoles… 2008… GSTP1        725.       601.   123.    2.48e- 1
    ## # … with more rows, and 2 more variables: f_statistic <dbl>, f_pvalue <dbl>
    ## 
    ## ----------
    ##  `grip` table
    ## 
    ## # Source:   table<grip> [?? x 9]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    ATC_concept_class_id ATC_concept_id ATC_concept_name Control MedDRA_concept_…
    ##    <chr>                         <int> <chr>            <chr>   <chr>           
    ##  1 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  2 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  3 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  4 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  5 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  6 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  7 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  8 ATC 5th                    21602320 isotretinoin     N       PT              
    ##  9 ATC 5th                    21602320 isotretinoin     N       PT              
    ## 10 ATC 5th                    21602320 isotretinoin     N       PT              
    ## # … with more rows, and 4 more variables: MedDRA_concept_id <int>,
    ## #   MedDRA_concept_name <chr>, ade <chr>, ade_name <chr>
    ## 
    ## ----------
    ##  `ryan` table
    ## 
    ## # Source:   table<ryan> [?? x 4]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    condition_name     meddra_concept_id atc_concept_id control 
    ##    <chr>                          <int>          <int> <chr>   
    ##  1 Acute liver injury          35909435       21600111 negative
    ##  2 Acute liver injury          35909507       21600111 negative
    ##  3 Acute liver injury          35909516       21600111 negative
    ##  4 Acute liver injury          35205233       21600111 negative
    ##  5 Acute liver injury          36313585       21600111 negative
    ##  6 Acute liver injury          35909557       21600111 negative
    ##  7 Acute liver injury          35909611       21600111 negative
    ##  8 Acute liver injury          35909613       21600111 negative
    ##  9 Acute liver injury          35909589       21600111 negative
    ## 10 Acute liver injury          35909594       21600111 negative
    ## # … with more rows
    ## 
    ## ----------
    ##  `sider` table
    ## 
    ## # Source:   table<sider> [?? x 10]
    ## # Database: sqlite 3.37.0
    ## #   [/Users/nickgiangreco/GitHub/PDSdatabase/effect_peds_19q2_v0.3_20211119.sqlite]
    ##    ade               stitch_id meddra_concept_… medgen_id meddra_concept_… soc  
    ##    <chr>             <chr>     <chr>            <chr>                <int> <chr>
    ##  1 21600013_35707686 CID10000… Gingival bleedi… C0017565          35707686 Gast…
    ##  2 21600013_35707686 CID10000… Gingival bleedi… C0017565          35707686 Vasc…
    ##  3 21600013_35809243 CID10000… Pain             C0030193          35809243 Gene…
    ##  4 21600013_35809243 CID10000… Pain             C0234238          35809243 Gene…
    ##  5 21600013_36009711 CID10000… Hypersensitivity C0020517          36009711 Immu…
    ##  6 21600013_36009783 CID10000… Urticaria        C0042109          36009783 Immu…
    ##  7 21600013_36009783 CID10000… Urticaria        C0042109          36009783 Skin…
    ##  8 21600013_36110708 CID10000… Sinusitis        C0037199          36110708 Infe…
    ##  9 21600013_36110708 CID10000… Sinusitis        C0037199          36110708 Resp…
    ## 10 21600013_36110715 CID10000… Upper respirato… C0041912          36110715 Infe…
    ## # … with more rows, and 4 more variables: atc_concept_code <chr>,
    ## #   atc_concept_id <int>, atc_concept_name <chr>, ade_name <chr>
    ## 
    ## ----------

``` r
disconnect_sqlite_db(con)
```

# References

[Mind the developmental gap: Identifying adverse drug effects across
childhood to evaluate biological mechanisms from growth and
development](https://doi.org/10.7916/d8-5d9b-6738)

Giangreco, Nicholas P. and Tatonetti, Nicholas P., A Database of
Pediatric Drug Effects to Evaluate Ontogenic Mechanisms From Child
Growth and Development. Available at
[SSRN](https://ssrn.com/abstract=3898786) or
[DOI](http://dx.doi.org/10.2139/ssrn.3898786)
