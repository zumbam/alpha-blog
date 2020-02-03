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
    @sports.save
    category = Category.new(name: 'sports')
    assert_not category.valid?
  end

  test 'category is really unique due to cases' do
    @sports.save
    category = Category.new(name: 'Sports')
    assert_not category.valid?
  end

  test "category max length" do
    @sports.name = "a" * 26
    assert_not @sports.valid?
  end

  test "category min length" do
    @sports.name = "a" * 2
    assert_not @sports.valid?
  end



end
