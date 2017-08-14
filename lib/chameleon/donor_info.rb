class DonorInfo
  attr_reader :name, :total

  KILL_WORDS = %w(Mr. Mrs. Ms.)

  def initialize(name, total)
    @name = name
    @total = total
  end

  def cleaned_name
    cleaned = name

    KILL_WORDS.each { |kill_word| cleaned.gsub!(kill_word, '') }

    cleaned.strip
  end
end