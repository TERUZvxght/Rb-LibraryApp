# frozen_string_literal: true

class BookComponent < ViewComponent::Base
  def initialize(cover:, title:, author:)
    @cover  = cover
    @title  = title
    @author = author
  end
end
