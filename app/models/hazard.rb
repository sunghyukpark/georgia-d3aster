require 'roo'

class Hazard < ActiveRecord::Base

  def self.to_csv(options={})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |hazard|
        csv << hazard.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    header.map{|col| col.downcase!}
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      hazard = find_by_hazard_id(row["hazard_id"]) || new
      hazard.attributes = row.to_hash.slice(*row.to_hash.keys)
      hazard.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {})
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.trim_attributes(attr)
    attr.map{|col| col.downcase!.gsub('harzard_','')}
    attr.delete("id")
    attr << "hazard_id"
  end

end
