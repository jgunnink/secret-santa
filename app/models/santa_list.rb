class SantaLists < ActiveRecord::Base

  belongs_to :list
  belongs_to :santa

end
