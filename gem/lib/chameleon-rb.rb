require 'rubyXL'
require 'chameleon/donor_info'
require 'chameleon/reports/total_donation_report'

class Chameleon

  def self.total_donation_report(excel_file_path)
    excel_file = RubyXL::Parser.parse(excel_file_path)
    worksheet = excel_file.worksheets.first

    donor_information = worksheet.map do |row|
      has_cells = !!(row && row.cells && row.cells.first && row.cells.last)

      if has_cells && !row.cells.first.value.index('Total for').nil?
        DonorInfo.new(row.cells.first.value.gsub('Total for ', ''), row.cells.last.value)
      end
    end

    donor_information.compact!

    donor_information

    tiers = [
        10..99,
        100..199,
        200..499,
        500..999,
        1000...10000
    ]

    TotalDonationReport.generate!(donor_information, tiers, "donor-report.xlsx")
  end
end
