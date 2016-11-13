# This class handles the organising of santas and recipients
class List::ShuffleAndAssignSantas < ActiveJob::Base
  queue_as :default

  def initialize(list)
    @list = list
    @santas = @list.santas.to_a
  end

  def assign_and_email
    randomise_and_assign(@santas)
    @santas.each do |santa|
      AssignmentMailer.send_assignment(santa).deliver_later
    end
    # We override the validation here otherwise the is_locked validation kicks in
    # which prevents us from saving the instance of list.
    @list.update_attribute(:is_locked, true)
  end

private

  def randomise_and_assign(available_santas)
    list_size = available_santas.size
    shuffled_list = CircularList::List.new(available_santas.shuffle)

    list_size.times do
      santa = shuffled_list.fetch_previous
      recipient = shuffled_list.fetch_next

      santa.giving_to = recipient.id
      santa.save!

      shuffled_list.fetch_next
    end
  end
end
