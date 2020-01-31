require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  # self.use_instantiated_fixtures = true

  def setup
    @sports = Category.new(name: 'sports')
  end

  test "category normal instanciation" do
    assert @sports.valid?
  end

  test "name presence" do
    @sports.name = ''
    assert_not @sports.valid?
  end

  test "category uniqueness" do
    Category.create(name: 'sports')
    category = Category.new(name: 'sports')
    assert_not category.valid?
  end

  test "cathgory max length" do
    @sports.name = "a" * 26
    assert_not @sports.valid?
  end

  test "cathgory min length" do
    @sports.name = "a" * 2
    assert_not @sports.valid?
  end

end
