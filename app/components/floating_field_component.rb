# frozen_string_literal: true

class FloatingFieldComponent < ViewComponent::Base
  def initialize(form:, attribute:, autocomplete:, type: :text, autofocus: false)
    @form         = form
    @attribute    = attribute
    @autocomplete = autocomplete
    @type         = type
    @autofocus    = autofocus
  end
end
