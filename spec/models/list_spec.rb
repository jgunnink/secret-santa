require 'rails_helper'

RSpec.describe List do

  describe '@name' do
    it { should validate_presence_of(:name) }
  end
  
end
