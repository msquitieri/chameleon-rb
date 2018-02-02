require 'rubyXL'
require 'open-uri'
require 'chameleon/models/donor_info'
require 'chameleon/reports/total_donation_report'
require 'chameleon/parsers/quickbooks_parser'

class Chameleon

  def self.donation_letters(excel_file_path)
    donor_information = QuickbooksParser.parse(excel_file_path)

    donor_information.select! { |donor| donor.total > 100 }

    donor_information.each do |donor|
      puts "Generating PDF for #{donor.name}..."
      write_pdf!(donor)
    end
  end

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

  private

  def self.write_pdf!(donor)
    host = "http://localhost:3000"
    params = {
      name: donor.cleaned_name,
      amount: donor.total
    }

    url = "#{host}/receipt.pdf?#{URI.encode_www_form(params)}"

    open("donation-reports/#{donor.cleaned_name}.pdf", "wb") do |file|
      open(url) do |uri|
        file.write(uri.read)
      end
    end
  end
end
