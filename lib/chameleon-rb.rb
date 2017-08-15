require 'roo'
require 'chameleon/donor_info'
require 'chameleon/reports/total_donation_report'

class Chameleon

  def self.total_donation_report(excel_file_path)
    excel_file = Roo::Excelx.new(excel_file_path)

    donor_information = excel_file.map do |row|
      if row.first && !row.first.index('Total for').nil?
        DonorInfo.new(row.first.gsub('Total for ', ''), row.last)
      end
    end

    donor_information.compact!

    TotalDonationReport.generate!(donor_information, [10..50, 51..100, 300..500, 500..5000], "donor-report.xls")
  end
end
