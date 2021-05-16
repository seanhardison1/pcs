# pcs
## A data package for querying rider data from [procyclingstats.com](https://procyclingstats.com)

The goal of `pcs` is to provide programmatic methods for querying professional cyclist results and biographical information from [procyclingstats.com](https://procyclingstats.com).

### Installation

```
devtools::install_github("seanhardison1/pcs")
```

### Usage

The main function in `pcs` is `query_pcs`, which scrapes rider results and biographical information from the PCS website. Usage is as follows:

```
pcs::query_pcs("Peter Sagan", seasons = c(2020, 2021))
```

If no season years are specified, then `query_pcs` will pull all available data for the rider name(s) passed into the function as a character vector.

Rider results are returned as a list of two data frames: `profiles`, containing biographical information, and `results`, containing race results. The `results` data frame may contain numeric entries that pertain to DNF, DNS, DSQ, etc, and are defined as follows:

| Result flag | Code |
|-------------|------|
| DNF         | 999  |
| DNS         | 998  |
| OTL         | 997  |
| DF          | 996  |
| NQ          | 995  |
| DSQ         | 994  |

The `profiles` data frame contains columns for total UCI points in the categories of `one_day_races`, `gc`, `tt`, and `sprint`. Caution is warranted when analyzing rider biographical information from PCS. Never forget that these folks are more than just numbers!!
