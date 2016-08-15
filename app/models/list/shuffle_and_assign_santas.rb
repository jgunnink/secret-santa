class List::ShuffleAndAssignSantas

  def initialize(list)
    @list = list
    @santas = @list.santas
  end

  def assign
    @recipient_list = @santas.to_a
    @santas.each do |santa|
      check_validity_of_proposed_recipient(santa)
    end
  end

private

  def check_validity_of_proposed_recipient(santa)
    proposed_recipient = @recipient_list.sample
    if proposed_recipient != santa
      santa.giving_to = proposed_recipient.id
      santa.save!
      @recipient_list.delete(proposed_recipient)
    else
      if @recipient_list.count == 1
        # It can happen that the matcher leaves one person that can only be assigned
        # to themselves. If this happens, we have to run the whole method again.
        assign
      else
        check_validity_of_proposed_recipient(santa)
      end
    end
  end

end
