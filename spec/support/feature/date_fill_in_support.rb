module Feature
  module DateFillInSupport

    def fill_in_valid_gift_date
      within "#list_gift_day_1i" do
        select Date.tomorrow.strftime('%Y')
      end
      within "#list_gift_day_2i" do
        select Date.tomorrow.strftime('%B')
      end
      within "#list_gift_day_3i" do
        select Date.tomorrow.strftime('%-d')
      end
    end

    def fill_in_invalid_gift_date
      within "#list_gift_day_1i" do
        select Date.yesterday.strftime('%Y')
      end
      within "#list_gift_day_2i" do
        select Date.yesterday.strftime('%B')
      end
      within "#list_gift_day_3i" do
        select Date.yesterday.strftime('%-d')
      end
    end

  end
end
