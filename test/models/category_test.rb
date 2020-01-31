require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  self.use_instantiated_fixtures = true

  test "category normal instanciation" do
    assert @sports.valid?
  end

  test "name presence" do
    category = Category.new(name: '')
    assert_not category.valid?
  end

  test "category uniqueness" do
    category = Category.new(name: 'sports')
    assert_not category.valid?
  end

  test "cathgory max length" do
    category = @sports
    category.name = "a" * 26
    assert_not category.valid?
  end

  test "cathgory min length" do
    category = @sports
    category.name = "a" * 2
    assert_not category.valid?
  end

end
