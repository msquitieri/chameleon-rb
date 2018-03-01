require 'csv'
require 'chameleon/models/donor_info'

class KickstarterParser
  def self.parse(csv_file_path)
    rows = CSV.read(csv_file_path)
    header_row = rows.shift

    name_index = header_row.index('Backer Name')
    email_index = header_row.index('Email')
    pledge_index = header_row.index('Pledge Amount')

    rows.map do |row|
      name = row[name_index]
      email  = row[email_index]
      pledge = row[pledge_index].gsub('$', '').gsub(',', '').to_f

      DonorInfo.new(name, email, pledge)
    end
  end
end