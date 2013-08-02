require 'csv'
require 'date'
require_relative '../app/models/legislator'

VALID_FIELDS = ["title", "firstname", "lastname", "birthdate",
                "state", "in_office", "phone", "fax", "twitter_id",
                "website", "webform","party"]

class SunlightLegislatorsImporter
  def self.import(filename)
    csv = CSV.new(File.open(filename), :headers => true)
    csv.each do |row|
      legislator_hash = {}
      row.each do |field, value|
        # raise NotImplementedError, "TODO: figure out what to do with this row and do it!"
        if VALID_FIELDS.include?(field)
          if field == "phone" || field == "fax"
            m = value.match(/.?([2-9]\d{2}).*(\d{3}).*(\d{4})/)
            unless m == nil
              value = m[1] + m[2] + m[3]
            end 
          elsif field == "birthdate"
            m = value.match(/(\d{1,2}).(\d{1,2}).(\d{4})/)
            unless m == nil
              value = m[3]
              value += '0' if m[1].length == 1
              value += m[1]
              value += '0'
              value += m[2] if m[2].length == 1
            end
            # value = Date.parse(value) unless value == nil
          end
          legislator_hash[field.to_sym] = value
        end      
      end
      
      Legislator.create!(legislator_hash)
      print '.'
    end
  end
end

# IF YOU WANT TO HAVE THIS FILE RUN ON ITS OWN AND NOT BE IN THE RAKEFILE, UNCOMMENT THE BELOW
# AND RUN THIS FILE FROM THE COMMAND LINE WITH THE PROPER ARGUMENT.
# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end
