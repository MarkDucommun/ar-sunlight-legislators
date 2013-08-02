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
end