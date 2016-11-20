class ProcessedTransaction < ActiveRecord::Base

  belongs_to :list

  validates :list_id, presence: true
  validates :transaction_id, presence: true

end
