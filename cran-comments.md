## R CMD check results

0 errors | 0 warnings | 1 note

* The note refers to the 0.9GB sqlite file being downloaded during `R CMD check`. I did the following to ensure not to download the sqlite file: 1) On my local machine, I removed the kidsides directory from the cache directory "/Users/nickgiangreco/Library/Caches/org.R-project.R/R/", 2) I executed these commands in the package root directory: `R CMD build .` and `R CMD check --as-cran kidsides_0.5.0.tar.gz`,  and 3) I did not identify any new files or directories after executing `ls /Users/nickgiangreco/Library/Caches/org.R-project.R/R/`. 
