require 'rails_helper'

RSpec.describe List::ShuffleAndAssignSantas do

  describe "#assign_and_email" do
    subject { List::ShuffleAndAssignSantas.new(list).assign_and_email }

    # Santas should be assigned a giving_to value
    # Each santa should recieve an email
    # No santas should be unassigned

  end

end
