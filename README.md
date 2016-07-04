<!-- README.md is generated from README.Rmd. Please edit that file -->
chaint
======

"chain with a tee" - tee functions with magrittr/dplyr chains
-------------------------------------------------------------

Installation:
-------------

    devtools::install_github("jonocarroll/chaint")

Motivation:
-----------

`dplyr` chains are undoubtedly more readable than composed functions, and this makes processing of sequential steps much simpler. When written with line breaks, such as

``` r
mtcars %>% 
   group_by(cyl) %>% 
   summarise(abc = mean(mpg))
#> Source: local data frame [3 x 2]
#> 
#>     cyl      abc
#>   <dbl>    <dbl>
#> 1     4 26.66364
#> 2     6 19.74286
#> 3     8 15.10000
```

individual processing steps can be skipped over by commenting out a single line

``` r
mtcars %>% 
#   group_by(cyl) %>% 
   summarise(abc = mean(mpg))
#>        abc
#> 1 20.09062
```

The ouptut can then be viewed, and processing resumed.

Often we are interested in what is happening in the middle of this chain, or would like to do something conditionally. `magrittr::%T>%` provides a tee-like function which essentially boils down to

``` r
%T>% <- function(lhs, rhs) {
  eval(rhs)
  return(lhs)
}
```

This is useful for passing data to the `rhs` function which has side effects and for which the return value is to be discarded. However, `%T>%` doesn't take arguments, and the `rhs` function is required to do something with the incomming data.

`chaint` provides a similar function `tee` which is a more sophisticated version of `%T>%` which

    - still takes the data as input to the first argument, but
    - doesn't require the data to be used in any way, 
    - provides a mechanism for adding messages within a chain,
    - can be conditional on the data,
    - can take arguments to be passed on to the `rhs` function.

Example usage:
--------------

``` r
library(chaint)
mtcars %>% 
   group_by(cyl) %>% 
   say("caution, grouped data!") %>% 
   summarise(abc = mean(mpg))
#> caution, grouped data!
#> Source: local data frame [3 x 2]
#> 
#>     cyl      abc
#>   <dbl>    <dbl>
#> 1     4 26.66364
#> 2     6 19.74286
#> 3     8 15.10000
```
