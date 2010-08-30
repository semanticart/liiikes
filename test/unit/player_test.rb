require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "drafted_by" do
    assert_equal players(:drafter), players(:draftee).drafted_by
  end

  test "draftees" do
    assert_same_elements [players(:draftee), players(:additional_draftee)], players(:drafter).draftees
  end
end
