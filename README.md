<!-- README.md is generated from README.Rmd. Please edit that file -->
chaint
======

### "chain with a tee" - tee functions with magrittr/dplyr chains

Installation:
-------------

    devtools::install_github("jonocarroll/chaint")

Motivation:
-----------

`dplyr` chains are undoubtedly more readable than composed functions, and this makes processing of sequential steps much simpler. When written with line breaks, such as

``` r
mtcars %>% 
   group_by(cyl) %>% 
   summarise(meanMPG = mean(mpg))
#> Source: local data frame [3 x 2]
#> 
#>     cyl  meanMPG
#>   <dbl>    <dbl>
#> 1     4 26.66364
#> 2     6 19.74286
#> 3     8 15.10000
```

individual processing steps can be skipped over by commenting out a single line

``` r
mtcars %>% 
#   group_by(cyl) %>% 
   summarise(meanMPG = mean(mpg))
#>    meanMPG
#> 1 20.09062
```

The ouptut can then be viewed, and processing resumed.

Often we are interested in what is happening in the middle of this chain, or would like to do something conditionally. `magrittr::%T>%` provides a tee-like function which essentially boils down to

``` r
%T>% <- function(lhs, rhs) {
  do.call(rhs, lhs)
  return(lhs)
}
```

This is useful for passing data to the `rhs` function which has side effects and for which the return value is to be discarded. However, `%T>%` doesn't take arguments, and the `rhs` function is required to do something with the incomming data.

`chaint` provides a similar function `tee` which is a more sophisticated version of `%T>%` which

-   still takes the data as input to the first argument, but
-   doesn't require the data to be used in any way,
-   provides a mechanism for adding messages within a chain,
-   can be conditional on the data,
-   can take arguments to be passed on to the `rhs` function.

This is primarily intended for interactive use, not for programming with, as it it used for the side effect of printing to console.

Example usage:
--------------

To add a simple message (maybe a checkpoint flag or a notification about the processing), use `say` with a quoted message:

``` r
mtcars %>% 
   group_by(cyl) %>% 
   chaint::say("caution, grouped data!") %>% 
   summarise(meanMPG = mean(mpg))
#> caution, grouped data!
#> Source: local data frame [3 x 2]
#> 
#>     cyl  meanMPG
#>   <dbl>    <dbl>
#> 1     4 26.66364
#> 2     6 19.74286
#> 3     8 15.10000
```

The `tee` function prints a message and applies a function to the incomming data (with optional arguments) then transparently returns the incomming data to allow the chain to continue, allowing inspection of the intermediate data. No commenting out of lines.

``` r
mtcars %>%
  chaint::tee("checkpoint 1", head, n=10) %>%
  filter(cyl < 6) %>%
  chaint::tee("checkpoint 2", head, n=3) %>%
  summarise(meanMPG = mean(mpg))
#> checkpoint 1
#>                    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> Duster 360        14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> Merc 240D         24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230          22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Merc 280          19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> checkpoint 2
#>    mpg cyl  disp hp drat   wt  qsec vs am gear carb
#> 1 22.8   4 108.0 93 3.85 2.32 18.61  1  1    4    1
#> 2 24.4   4 146.7 62 3.69 3.19 20.00  1  0    4    2
#> 3 22.8   4 140.8 95 3.92 3.15 22.90  1  0    4    2
#>    meanMPG
#> 1 26.66364
```
