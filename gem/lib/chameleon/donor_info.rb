class DonorInfo
  attr_reader :name, :total

  KILL_WORDS = %w(Mr. Mrs. Ms.)

  def initialize(name, total)
    unless name.nil?
      @name = name.strip
    end

    @total = total
  end

  def cleaned_name
    cleaned = name.dup

    KILL_WORDS.each { |kill_word| cleaned.gsub!(kill_word, '') }

    cleaned.strip
  end

  def first_name
    name_arr.first unless name_arr.nil?
  end

  def last_name
    name_arr.last unless name_arr.nil?
  end

  def in_tier?(range)
    range.include?(total)
  end

  private

  def name_arr
    cleaned = cleaned_name
    unless cleaned.nil?
      cleaned.split(' ')
    end
  end
end