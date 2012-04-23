#
# The GoF Strategy pattern
# written by Matthieu Tanguay-Carel
#
# Sorter is the Context object. It allows to choose between sorting
# implementations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class QuickSort
    def sort arr
        return [] if arr.length == 0
        x, *xs = *arr
        smaller, bigger = xs.partition{ |other| other < x }
        sort(smaller) + [x] + sort(bigger)
    end
end

class MergeSort
    def sort array
        if array.length <= 1
            return array
        end
        middle = array.length / 2
        left = array[0...middle]
        right = array[middle...array.length]
        left = sort left
        right = sort right
        return merge(left,right)
    end
 
    def merge left,right
        result = []
        while left.length > 0 and right.length > 0
            left.first <= right.first ? result << left.shift : result << right.shift
        end
        result.push *left if left.length > 0
        result.push *right if right.length > 0
        return result
    end
end

class Sorter
    @@default_strategy = QuickSort.new
    def self.sort arr, strategy=nil
        strategy ||= @@default_strategy
        strategy.sort(arr)
    end
end

def print_elems arr
    arr.each {|elem| $stdout.write "#{elem} "}
    puts ''
end

def get_random_array size
    arr = []
    size.times do arr << rand(100) end
    arr
end

require 'benchmark'
if __FILE__ == $0
    arr_length = 1000
    arr1 = get_random_array arr_length
    puts "Sorting first array"
    #print_elems arr1
    puts "Time taken for QuickSort: #{Benchmark.measure {
        arr1 = Sorter.sort(arr1, QuickSort.new)
        print_elems arr1[0...40]
    }}"

    puts "\nSorting second array"
    arr2 = get_random_array arr_length
    #print_elems arr2
    puts "Time taken for MergeSort: #{Benchmark.measure {
        arr2 = Sorter.sort(arr2, MergeSort.new)
        print_elems arr2[0...40]
    }}"
end

