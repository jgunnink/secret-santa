module Capybara
  class Session
    def has_flash?(name, value=nil)
      has_css?(".flash.flash-#{name}", text: value)
    end

    def has_error_message?(field, message)
      has_css?("[class*='#{field}'].field_with_errors .error", text: message)
    end

    def has_hint_message?(field, message)
      has_css?("[class*='#{field}'] .hint", text: message)
    end
  end
end
