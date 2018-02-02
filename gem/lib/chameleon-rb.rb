require 'rubyXL'
require 'chameleon/models/donor_info'
require 'chameleon/reports/total_donation_report'
require 'chameleon/parsers/quickbooks_parser'

class Chameleon

  def self.total_donation_report(excel_file_path)
    donor_information = QuickbooksParser.parse(excel_file_path)

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
