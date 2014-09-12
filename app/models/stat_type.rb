class StatType < ActiveRecord::Base
  has_many :stats

  before_validation :build_identification

  validates :identifier, uniqueness: true

  private

  def build_identification
    self.identifier = Manipulator.underscore(name)
  end
end
