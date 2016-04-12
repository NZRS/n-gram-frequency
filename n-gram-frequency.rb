#!/usr/bin/ruby

# n-gram-frequency.rb
#
#
# Calculates an n-gram frequency table for a file of strings and optionally
# uses that frequency table to calculate a metric for the same or another
# file of strings.  The metric is defined as
#
# Sum(1 / frequency_of_n_gram) / number_of_n_gram
#
# Where an n-gram is not found in the frequency table then an adjustable
# score is added to the metric.
#
# Optionally writes out the frequency table to a file.
#
# Copyright (c) 2016 NZRS Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.#

$arguments = ARGV.length

if $arguments == 0
  print "usage: n-gram-frequency input [-o output] [-t input_table] [-n size] [-m misses] [-w output_table]
        
 Calculates an n-gram frequency table for a file of strings and optionally
 uses that frequency table to calculate a metric for the same or another
 file of strings.  The metric is defined as
  
 Sum(1 / frequency_of_n_gram) / number_of_n_gram
  
 Where an n-gram is not found in the frequency table then an adjustable
 score is added to the metric.

 Optionally writes out the frequency table to a file.

 input:
      The name of the file containing one string per line.

 Options:
  -o  Calculate the metric for each string in the inout file and save the
      output in the specified file name.  Defaults to 'output.csv'.

  -t  Use the specified frequency table file instead of one generated from
      the input file.  Defaults to 'table.csv'.  

  -n  Use n-grams of the specified size.  Defaults to 2.

  -m  Add the specified score to the metric for hash table misses.  
      Defaults to 2.0.

  -w  Write out generated hash table.  Pointless using this if -t
      has also been specified.  Defaults to 'table.csv'.\n"
  exit(0)
end


# set up the global variables
$arg_o = false
$arg_t = false
$arg_w = false

$table = Hash.new
$output = Hash.new
$ifile = ARGV[0]
$ofile = "output.csv"
$input_table = "table.csv"
$output_table = "table.csv"
$misses = 2.0
$ngram = 2

# process the other arguments
previous = ""

if $arguments > 1
  ARGV[1, $arguments-1].each do |a|
    case a
    when "-o"
      $arg_o = true
      previous = "o"
    when "-t" 
      $arg_t = true
      previous = "t"
    when "-n"
      previous = "n"
    when "-m"
      previous = "m"
    when "-w"
      $arg_w = true
      previous = "w"
    else
      case previous
      when "o"
        $ofile = a
      when "n"
        $ngram = a.to_i
      when "m"
        $misses = a.to_f
      when "t"
        $input_table = a
      when "w"
        $output_table = a
      end
    end
  end
end


#  Fill hash table
if $arg_t
  # use an existing hash table
  File.open($input_table, "r") do |f|
    while line = f.gets
      line = line.chomp
      parts = line.split(",")
      $table[parts[0]] = parts[1].to_f
    end
  end
else
  # caclulate the hash table using the input file
  File.open($ifile, "r") do |f|
    while line = f.gets
      line = line.chomp
      len = line.length
      if len > 1                          # don't bother if only 1 character
        for i in 0..(len - $ngram)
          chars = line[i, $ngram]
          $table[chars] ? $table[chars] = $table[chars] + 1 : $table[chars] = 1
        end
      end
    end
  end
end


#  Calculate the metric
if $arg_o
  File.open($ifile, "r") do |f|  
    while line = f.gets
      score = 0.0
      line = line.chomp
      len = line.length
      if len > 1
        for i in 0..(len - $ngram)
          chars = line[i, $ngram]
          if $table.key?(chars) 
            score += 1.0 / $table[chars]
          else
            score += $misses       # only needed if we use a different table
          end
        end
        $output[line] = score / (len - $ngram + 1)
      end
    end  
  end

  # write output
  File.open($ofile, "w") do |f|
      for k in $output.keys
        f.print(k + ",#{$output[k]}\n")
      end
  end
end


# optionally write table
if $arg_w
  File.open($output_table, "w") do |f|
    for k in $table.keys
      f.print(k + ",#{$table[k]}\n")
    end
  end
end


