ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def sign_in(email:, password:)
    post login_path, params: {session: {email: email, password: password}}
  end

  def create_test_article(user:,categories:[], title: 'test', description: 'this is a test')
    Article.create(title: title, description: description, user: user, categories: categories)
  end
end
