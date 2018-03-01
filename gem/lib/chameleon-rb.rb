require 'rubyXL'
require 'open-uri'
require 'chameleon/models/donor_info'
require 'chameleon/reports/total_donation_report'
require 'chameleon/parsers/quickbooks_parser'
require 'chameleon/parsers/kickstarter_parser'

class Chameleon

  TIERS = [
    10..99,
    100..199,
    200..499,
    500..999,
    1000...10000
  ]

  def self.parse_kickstarter(directory_path)
    donors = []
    Dir.foreach(directory_path) do |item|
      next if item == '.' || item == '..'

      donors << KickstarterParser.parse("#{directory_path}/#{item}")
    end

    donors.flatten!

    TotalDonationReport.generate!(donors, TIERS, "kickstarter-report.xlsx")
  end

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

    TotalDonationReport.generate!(donor_information, TIERS, "donor-report.xlsx")
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
