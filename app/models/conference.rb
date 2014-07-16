class Conference < ActiveRecord::Base
  has_many :attendances
  has_many :confirmed_attendees, -> { where(confirmed: true) }, through: :attendances, source: :team
  has_many :attendees, through: :attendances, source: :team

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }

  def tickets_left
    tickets - attendances.size
  end
end
