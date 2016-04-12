# n-gram-frequency

An n-gram is a sequence of characters 1 or more characters long.  The default length as used in this tool is 2 and a different size can be specified with the -n option.  It is often useful to look at text from the perspective of the frequencies of certain n-grams and how those compare to the frequencies for a reference body of text.  This program helps to do that by carrying out the following calculations on n-gram frequencies:

1. calculating an n-gram frequency table for a file of strings
2. Uses that frequency table (or another) to calculate a metric for the same or another file of strings.

## calculating the n-gram frequency table
The program takes a file which has one word per list and for each words splits it into all the n-grams and records the total number of each n-gram found in the file in a hash table.  For example, the word 'doctor' is split into the following 2-grams (n-grams of size 2): do oc ct to or.

This has table can be written out using the -w option.  For example:
```
./n-gram/frequency.rb top-5000.csv -w top-5000-freq.csv
```
generates the file top-freq.csv, which has the first five lines as follows:
```
th,171
he,157
be,80
an,344
nd,182
```

## calculating the metric
The second function is to calculate a metric for either the same file of strings or another file.  Once again the file should have one word per line.  To output the metric the -o option is used and optionally the name of a file can be given.

This metric is defined as

Sum(1 / frequency_of_n_gram) / number_of_n_gram

Where an n-gram is not found in the frequency table then an adjustable score is added to the metric.

