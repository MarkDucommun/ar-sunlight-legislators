    require_relative '../../db/config'

class Legislator < ActiveRecord::Base
  # validates :phone, format: { with: /\d{10}/}
  validate :validate_phone
  # validates :fax, format: { with: /\d{10}/}
  validate :validate_fax
  validates_presence_of :title, :firstname, :lastname, :state, :state
  
  def validate_phone
    unless :phone.present? && !:phone.match(/\d{10}/)
      errors.add(:phone, "must be valid phone number")
    end
  end

    def validate_fax
    unless :fax.present? && !:fax.match(/\d{10}/)
      errors.add(:fax, "must be valid phone number")
    end
  end

  def to_s
    "#{firstname} #{lastname}"
  end

  def self.get_legislators_for_state(state)
    ["Senators:", "Representatives:"].each do |type|
      puts type
      people = Legislator.where(state: state, title: type[0,3]).order('lastname')
      people.each do |person|
        puts "  #{person.firstname} #{person.lastname} (#{person.party})"
      end
    end 
  end
end
