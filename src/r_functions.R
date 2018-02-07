library(Hmisc)
library(tidyr)
library(dplyr)
library(stringr)

find_percent <- function(df, label_col, num_obs, sep='&'){
    ##find the ratio of a certian value which includes the label
    ##--------
    ##INPUTS
    ##df: data.frame
    ##    - dataframe with all catagorical data
    ##label_col
    ##    -   binary column of interest in df
    ##num_obs: named.vector
    ##     -   contains all possible values in df with the  correlated number of observations
    ## --------
    ## RETURNS
    ## percent_pos: named.vector
    ##     -   contains the percentage of each value within the dataframe which is associated with the label_column.
    percent_pos <- c()
    sub <- df[,label_col] == TRUE
    sub_df <- df[sub,]
    for(col_val in names(num_obs)){
        colval <- unlist(strsplit(col_val, sep))
        percent_pos[col_val] = ((sum(sub_df[,colval[1]] == colval[2]) + .0001))  / (num_obs[col_val] + .0001)
        }
    return(percent_pos)
    }

find_number_observations <- function(df, sep='&', check_na=FALSE){
    num_obs= c()
    for (col in names(data_binned)){
        if(check_na){
            num_obs[paste(col, 'isna', sep=sep)] = sum(is.na(data[,col])) / dim(df)[1]
            }
        for (value in unique(data_binned[,col]))
            {
            num_obs[paste(col, value, sep=sep)] = sum(data_binned[,col] == value)
            }
    }
    return(num_obs)
}

make_dummy <- function(df, sep='&', cat_but_keep=c(), known_cats=c(), drop_others=FALSE){
    # takes original dataframe and converts all values with less then 8 unique sets, and 
    # non-numeric data to dummy variables
    # --------
    # INPUTS
    # df: data.frame
    #     -   Data should all be catagorical.
    # sep: str
    #     -   Character to use as seperator between column and value
    # subcols: bool or array
    #   -   subset of all columns which contain columns to ignore
    # --------
    # RETURNS
    # dfo: data.frame
    #     -   all data is bool
    dfo <- df
    for(col in names(select(df,-one_of(cat_but_keep)))){
        if( col %in% known_cats |
            is(df[,col])[1] == 'factor' | 
            length(unique(dfo[,col])) < 8){
            print(col)
            vals <- unique(dfo[,col])[-1]
            for(val in vals[2:length(vals)]){
                dfo[, paste(col, val, sep=sep)] = dfo[, col] == val
            }
            dfo <- dfo[, names(dfo) != col]
        }
    }
    return(dfo)
}

fill_nulls <- function(df, null_sep='_isNA'){
    for(col in names(df)){
        nans <- is.na(df[,col])
        if(sum(nans) > 0){
            if('factor' %in% is(df[,col])){
                ncol <- as.character(addNA(df[,col]))
                ncol[nans] <- null_sep
                df[col] <- factor(ncol)
            }
            else{
                print(col)
                df[nans, col] <- median(df[!nans, col])
                df[, paste(col, null_sep, sep='')] <- nans
            }
        }
    }
    return(df)
}

find_covariance <- function(df, items, sep='+'){
    # Take a subset of columns in df and find the covariance between them
    # ---------
    # INPUTS
    # df: data.frame
    #     -   All data inputs must of type bool
    # items: data.frame
    #     -   columns in the dataframe to compare to each other
    # sep: str
    #     -   character to use to seperate columns being compared
    # --------
    # RETURNS
    # covar: named vector
    #     -   sets of column names seperated by sep with duplicates and self correalations removed
    covar = c()
    for(col1 in items){
        for(col2 in items){
            if(col1 != col2){
                covar[paste(col1, col2, sep='+')] = (sum(df[,col1] == TRUE & df[,col2] == TRUE) + .00001) / (max(c(sum(df[,col1] == TRUE), sum(df[,col2] == TRUE))) + .00001)
                }
            }
        items = items[items != col1]
        }
        covar <- covar[order(-covar)]
        return(covar[c(TRUE, FALSE)])
    }

bin_columns <- function(data, min_size=100, num_splits){
    # Convert continous data into discrete catagorical data
    # by splitting continous data into equal sized (by number of members) groups.
    # --------
    # data: data.frame
    #     -   data frame which contains continous data
    # min_size: integer
    #     -   min number of members in a group (determine split pts). columns with less discrete points then this value will be ignored.
    # num_splits
    #     -   number of times to split continous dataset
    # --------
    types <- sapply(data, class)
    data_binned <- data
    for(col in names(types)){
        if(types[[col]] == 'integer' & length(unique(data[,col])) > num_splits){
            data_binned[col] <- cut2(data[,col], m=min_size, g=num_splits)
            data_binned[,col] = sapply(data_binned[,col], toString)
            }
        else{
            data_binned[,col] = sapply(data[,col], toString)}
        }
    names(data_binned) <- sapply(names(data_binned), str_trim)
    return(data_binned)
    }

make_balanced_df <- function(df, label){
    train_1 <- sample(c(TRUE, FALSE), dim(df)[1], replace=TRUE, prob=c(.8, .2))
    tdf <- subset(df, label != 0)
    sub_data <- subset(df, label == 0)
    df_bal <-rbind(tdf, sample_n(sub_data, dim(tdf)[1], replace=FALSE))
    return(df_bal <-rbind(tdf, sample_n(sub_data, dim(tdf)[1], replace=FALSE)))
}    


train_bool_arrays <- function(df, label, test_percent=.2, num_frames=5, rand_seed=42){
    tp <- test_percent
    set.seed(rand_seed)
    df_bal <- make_balanced_df(df, label)
    df_bal['train'] = sample(c(TRUE, FALSE), dim(df_bal)[1], replace=TRUE, prob=c(1-tp, tp))
return(df_bal)
}


check_label_corelation <- function(df, label, dsep='&', sd_ratio=1){
## function to generate top contributing variables to a specific label
##--------
##INPUTS
##df: data.frame
##  -   contains all catagorical variables, label col must be T/F
##label: string
##  -   name of label column
##sep: str
##  -   character to use in seperating dummy values from col name
##--------
##RETURNS
## coors: named_vector
##  -   contains coorelation rate for each value in the df
    all_pos <- sum(df[,label] == TRUE) / dim(df)[1]
    num_obs <- find_number_observations(df, sep=dsep)
    percent_pos <- find_percent(df, label, num_obs, sep=dsep)
    label_frame <- data.frame(percent_pos, num_obs)
    label_frame[,'ratio_delta'] <- label_frame$percent_pos - all_pos
    not_label <- (rownames(label_frame) != paste(label, 'TRUE', sep=dsep) & rownames(label_frame) != paste(label, 'FALSE', sep=dsep)) 
    label_frame <- label_frame[not_label,]
    one_dev <- sd(label_frame[,'ratio_delta']) * sd_ratio
    label_infl <- label_frame[abs(label_frame[,'ratio_delta']) > one_dev,]
    return(label_infl[order(-label_infl$ratio_delta),])
}


but_I_regress <-function(df, model, label, thres=50, dsep='&'){
    ##
    ##
    ##
    ##
    df.te <- df[df[,'train'] == FALSE,]
    df.te[,'predicted'] <- predict(fit, df.te[,names(dfd) != label])
    df.te['posi'] <- df.te['predicted'] > thres
    df.te['correct'] <- df.te['posi'] == df.te[label]
    return(df.te)
    #error = sum((dfd[, label] - dfd[,'predicted'])**2)
    # sqrt(error / dim(dfd[,names(dfd) != label])[1])

}

featurize_frame <- function(df, label, csep='&'){
    snam <- names(df)
    no_labs <- df[,snam[(snam != label & snam != 'train')]]
    types <- sapply(no_labs, class)
    cat_cols <- names(types)
    idx = 1
    for(col in names(types)){
        if(types[[col]] == 'integer'){
            cat_cols = cat_cols[cat_cols != col]
            df[,col] = df[,col] / max(df[,col])
            }
        }
    dfd <- make_dummy(df, subcols=cat_cols)
    #dfd[,label] <- df[,label]
    #dfd[,'train'] <- df[,'train']
    return(dfd)
    }

gen_train_frame <- function(df, label, ptest=.2){
    # df[,label]  <- df[,label] == TRUE
    df[,label]  <- df[,label] * 100
    tdf <- df[df[,label] != 0,]
    sub_data <- df[df[,label] == 0,]
    df_bal <- rbind(tdf, sample_n(sub_data, dim(tdf)[1], replace=FALSE))
    df_bal$train <- sample(c(TRUE, FALSE), 
                    dim(df_bal)[1], 
                    replace=TRUE, 
                    prob=c(1-ptest, ptest))
    return(df_bal)
}

subset_use_cols <- function(df, train_frame, label, min_qt=.75, csep= '&'){
    infl <- check_label_corelation(data_binned, label, '&')
    infl$percent_sq <- infl$percent_pos ** 2
    min_inf <- quantile(infl$percent_sq, min_qt)
    alls <- subset(infl, percent_sq >= min_inf)
    tups <- str_split(row.names(alls), pattern=csep)
    first_cell <- function(x){x[1]}
    use_cols <- unique(sapply(tups, first_cell))
    return(train_frame[,append(use_cols, c(label, 'train'))])
}

Attrition_prop_table <- function(variable_name, data.f){
    # Generates a table containing proportion of responses for both Attrition values. This should allow us to examine values in the context of whether they attrified.
    
    # Generate a table containing variable/Attrition rates
    prop <-prop.table(xtabs(as.formula(paste( '~ ',paste(variable_name, 'attrition ', sep = ' + '))) , data=data.f))
    
    #Normalize each column to sum to 1.
    prop.app <-apply(prop,2,sum)
    return(melt(sweep(prop, MARGIN=2,prop.app,'/')))
}