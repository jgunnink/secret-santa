module Feature
  module NavigationSupport
    def click_header_option(option)
      within(".navigation-wrapper") do
        click_link(option)
      end
    end
  end
end
