class Contract < ApplicationRecord
  belongs_to :vendor
  belongs_to :category
  belongs_to :user

  validates :costs, presence: true, numericality: { greater_than: 0.0 }
  validates :vendor, presence: true
  validates :category, presence: true
  validates :ends_on, presence: true
  validate :category_belongs_to_vendor, if: :vendor_or_category_changed?
  validate :ends_on_is_in_the_future, if: proc { |m| m.ends_on_changed? }

  delegate :name, to: :vendor, prefix: true
  delegate :name, to: :category, prefix: true

  private

  def category_belongs_to_vendor
    errors.add(:category, :confirmation) unless vendor.category_exists?(category.id)
  end

  def ends_on_is_in_the_future
    errors.add(:ends_on, :inclusion) if ends_on.present? && ends_on <= Time.now.utc.to_date
  end

  def vendor_or_category_changed?
    vendor_id_changed? || category_id_changed?
  end
end
