    require_relative '../../db/config'

class Legislator < ActiveRecord::Base
  validate :validate_phone
  validate :validate_fax
  validates_presence_of :title, :firstname, :lastname, :state
  
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

  def self.get_by_state(state)
    ["Senators:", "Representatives:"].each do |type|
      puts type
      people = Legislator.where(state: state, title: type[0,3]).order('lastname')
      people.each do |person|
        puts "  #{person.firstname} #{person.lastname} (#{person.party})"
      end
    end 
  end

  def self.get_percent_by_gender(gender)
    ["Senators:", "Representatives:"].each do |type|
      total_count = Legislator.where(title: type[0,3], in_office: true).count
      gender_count = Legislator.where(title: type[0,3], gender: gender, in_office: true).count
      percent = gender_count.to_f / total_count * 100
      puts "#{ gender } #{ type } #{ gender_count } (#{ percent.to_i }% )"
    end
  end

  def self.states_by_legislature_size
    by_state = Legislator.select("count(*) as count_all").order("count_all DESC").group(:state).count
    by_state.each do |state, count|
      puts "#{state}: 2 Senators, #{count - 2} Representative(s)" unless count < 3
      puts "#{state}: #{count} Representative(s)" unless count > 2
    end
  end

  def self.all_legislators_by_position
    ["Senators:", "Representatives:"].each do |type|
      puts "#{type} #{Legislator.where(title: type[0,3]).count}"
    end
  end

  def self.delete_inactive_legislators
    Legislator.where(in_office: false).destroy_all
  end
end
