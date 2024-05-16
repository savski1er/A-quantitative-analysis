                     Random Sampling Macro
                           version 1.4
                         Charles Burchill
             Manitoba Centre for Health Policy and Evaluation.
                          October 18, 1995

This program is used to extract a user defined random sample from a
SAS dataset.

Thanks to Ruth, Shelley, and Randy for their suggestions. Much of the
code was modified from the SAS Applications Guide, 1987 Edition pp. 227-231.

Call:
       _random options ;

Options:
        data=    Data set name, default is the last open dataset.
        output=  Output dataset name (required).
        seed=    Seed value for SAS random number lookup, default system time.
        sample=  Size of the sample, total or within in each by group.
        percent= Size of sample based on % of dataset size, or by group size.
                 One of Sample or Percent is required, if both are
                 provided sample is used.
        by=      Variable(s) to sample by.
                 Multiple variables must be enclosed in quotes
                 (e.g. by="hosp agegrp").
        min=     Minimum size in a % sample by group.
        debug=   Turn on or off debuging (=debug, =nodebug).

Example Calls:
   * Randomly sample claims within each hospital
     With at least 5 samples (if there are that many). ;
   _random percent=50  seed=5 min=5
        data=test by=hosp
        output=dump ;

   * Randomly select 100 claims from a dataset;
   _random sample=100
           seed=5
           data=hosp
           output=sample ;

Notes:
   - Samples are defined in the following ways:
     1. Normal sample (no by groups).   This dataset is used with the point
        command to select observations out of non-compressed
        SAS datasets. The sample is selected according to the
        probabilities conditional on the number of observations 
        remaining in the data set, and the number needed to complete
        the sample.This method means that the dataset does not
        have to be sorted or loaded into a temporary data set first.
        It is much faster than adding a variable containing a random
        number, sorting and selecting.  
     2. If the dataset is compressed, or if it is a SAS view the
        data is read into a temporary dataset first.  The sample
        is selected as above.
     3. By variable samples. The data set is sorted by the by group
        list into a temporary data set. The sample is selected 
        according to the probabilities conditional on the number of
        observations remaining in that by group, and the number needed
        to complete the sample.
        
   - Percent sample sizes are based on the data set size (or the
     by group size).  This means a 20% sample of 10000 observations
     will be 200. This program does not use an approximation.
   - Remember that when you sub-sample with by groups that the total
     size of the output dataset may not be a multiple of the sample
     size, or the percentage of the original.
     1. Some by groups may not be large enough to draw a complete sample
     2. The percent sample is selected as a percent of each by group
        not the total dataset.
   - If any by group is smaller than the defined sample, or minimum
     sample size the macro will return a note.
