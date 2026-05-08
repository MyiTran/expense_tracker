class Transaction < ApplicationRecord
  enum category: { food: 0, transport: 1, shopping: 2, entertainment: 3, salary: 4, other: 5 }

  validates :title, :amount, :transaction_date, :category, presence: true

  # xử lý dữ liệu từ form
  before_validation :cast_category_to_integer

  private

  def cast_category_to_integer
    self.category = category.to_i if category.is_a?(String) && category.match?(/\A\d+\z/)
  end
end
