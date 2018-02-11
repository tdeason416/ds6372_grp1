rm( list = ls()); cat("\014")  # Clear environment
require(stringr)
require(plotly)
require(Hmisc)
require(tidyr)
require(dplyr)
require(ggplot2)
require(plyr)
require(reshape2)
source('../src/r_functions.R')
data <- read.csv('../data/train.csv')
names(data) <- sapply(names(data), tolower)
```


```{r}
dfnan <- fill_nulls(data)
```




```{r}
dfo <- make_dummy(dfnan, sep='_',
                  known_cats = c('mssubclass'), 
                  cat_but_keep=c('fireplaces','garagecars', 'yrsold', 'fullbath', 'halfbath', 'kitchenabvgr', 'bsmtfullbath', 'bsmthalfbath',
                                 'lotfrontage_isNA', 'masvnrarea_isNA', 'garageyrblt_isNA'))
```

```{r}
write.csv(dfo, '../data/train_clean.csv')
```



```{r}
data2 <- read.csv('../data/test.csv')
df2_nan <- fill_nulls(data)
```

```{r}
df2 <- make_dummy(df2_nan, sep='_',
                  known_cats = c('mssubclass'), 
                  cat_but_keep=c('fireplaces','garagecars', 'yrsold', 'fullbath', 'halfbath', 'kitchenabvgr', 'bsmtfullbath', 'bsmthalfbath',
                                 'lotfrontage_isNA', 'masvnrarea_isNA', 'garageyrblt_isNA'))
```
```{r}
write.csv(df2,'../data/test_clean.csv')
