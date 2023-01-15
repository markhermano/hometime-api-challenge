class Reservation < ApplicationRecord
  belongs_to :guest

  validates_presence_of :code
  validates_uniqueness_of :code

  accepts_nested_attributes_for :guest, reject_if: :all_blank

  serialize :guest_details, Hash
end
