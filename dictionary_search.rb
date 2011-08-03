require 'rubygems'
require 'active_support'

class DictionarySearch
  attr_accessor :words

  def initialize(file_path)
    self.words = file_to_array(file_path)
    words.delete_if{|item| invalid?(item)}
  end

  def word_pairs
    result = []
    hash = array_to_hash(words)

    hash.each_key do |key|
      swap_element = swap_chars(key)
      if hash[swap_element]
        hash.delete key
        hash.delete swap_element
        result << [key, swap_element]
      end
    end

    result
  end

  def array_to_hash(array)
    hash = {}

    array.each do |element|
      eval("hash.merge!(#{"element"} => #{"element"})")
    end

    hash
  end

  def invalid?(string)
    return true if invalid_size?(string)
    invalid_chars?(string)
  end

  def swap_chars(string)
    swap_string = string.dup
    swap_string[-2,2] = swap_string[-2,2].reverse
    swap_string
  end
  
  def invalid_chars?(string)
    string == swap_chars(string)
  end

  def invalid_size?(string)
    string.size < 3
  end

  def file_to_array(file_path)
    File.open(file_path) do |file|
      file.readlines.each {|item| item.chop!}
    end
  end
end
