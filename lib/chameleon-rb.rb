require 'roo'
require 'chameleon/donor_info'

class Chameleon

  def self.total_donation_report(excel_file_path)
    excel_file = Roo::Excelx.new(excel_file_path)

    donor_information = excel_file.map do |row|
      if row.first && !row.first.index('Total for').nil?
        DonorInfo.new(row.first.gsub('Total for ', ''), row.last)
      end
    end

    donor_information.compact!

    donor_information
  end
end
