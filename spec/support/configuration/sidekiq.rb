require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all
  end

  config.around(:each) do |example|
    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!(&example)
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!(&example)
    elsif example.metadata[:sidekiq] == :enabled
      Sidekiq::Testing.disable!
      example.call
      Sidekiq::ScheduledSet.new.each(&:delete)
    elsif example.metadata[:type] == :feature
      Sidekiq::Testing.inline!(&example)
    else
      Sidekiq::Testing.fake!(&example)
    end
  end
end
