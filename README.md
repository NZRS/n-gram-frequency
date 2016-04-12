# n-gram-frequency

A Ruby command line tool for working with n-gram frequencies.

An n-gram is a sequence of characters 1 or more characters long.  The default length used is 2 and a different size can be specified with the -n option.  It is often useful to look at text from the perspective of the frequencies of certain n-grams and how those compare to the frequencies for a reference body of text, which this program helps to do by carrying out the following calculations on n-gram frequencies:

1. calculating an n-gram frequency table for a file of strings
2. Uses that frequency table (or another) to calculate a metric for the same or another file of strings.

## calculating the n-gram frequency table
The program takes a file which has one word per list and for each words splits it into all the n-grams and records the total number of each n-gram found in the file in a hash table.  For example, the word 'doctor' is split into the following 2-grams (n-grams of size 2): do oc ct to or.

This has table can be written out using the -w option.  For example:
```
./n-gram-frequency.rb top-5000.csv -w top-5000-freq.csv
```
generates the file top-freq.csv, which has the following first five lines:
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
```
sum(1 / frequency_of_n_gram) / number_of_n_grams
```
For example:
```
./n-gram-frequency.rb test.csv -o - t top-5000-freq.csv
```
generates the file output.csv, which has the following first five lines:
```
trademe,0.005851064944013533
stuff,0.045435705559868325
nzherald,0.4342321309988272
westpac,0.08982746716824135
kiwibank,0.3035078751121378
```
Where an n-gram is not found in the frequency table then a score is added to the metric, defaulting to 1 and changed by the -n option.

## Example data
The example data used to create the frequency table in the example is a list of 5000 most common words from http://www.wordfrequency.info/top5000.asp in file called top-5000.csv.  The list of test names is 10 popular domain names in .nz with the TLD suffices removed.

