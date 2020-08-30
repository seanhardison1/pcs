# pcs
## A data package for analyzing aggregated rider data from [procyclingstats.com](https://procyclingstats.com)

Just in time for the Tour de France, `pcs` contains the complete race results from both men and women riders ranked within the top 100 in the PCS Individual Rankings (as of 08/29/2020). New rider data will be 
added as rankings change from week to week.

### Installation
```
devtools::install_github("seanhardison1/pcs")
```

### Usage

```
pcs::rider_records_women
pcs::rider_records_men
```
Rider results are returned as a `tibble` with the column `result` indicating finishing place. When a rider is listed as DNF, DNS, or DSQ etc, their 
results are encoded numerically as follows:

| Result flag | Code |
|-------------|------|
| DNF         | 999  |
| DNS         | 998  |
| OTL         | 997  |
| DF          | 996  |
| NQ          | 995  |
| DSQ         | 994  |
  
### Convert from CSV to sqlite 
In case you want to work with SQL instead of CSV, it can be converted.  
The only dependency is the sqlite3 CLI program itself and it needs to be on the $PATH for the script to work.

To do so : cd to the `scripts` dir and execute `csv_to_sqlite`, it should generate two .sqlite files  
* `data/rider_records_men.sqlite`
* `data/rider_records_women.sqlite`
