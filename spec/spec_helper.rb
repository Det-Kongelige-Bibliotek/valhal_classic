# -*- encoding : utf-8 -*-
require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start  'rails'
  end
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    config.include Capybara::DSL
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    def fixture(file)
      File.new(File.join(File.dirname(__FILE__), 'fixtures', file))
    end

    def create_basic_file(holding_object)
      basic_file = BasicFile.new
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      basic_file.add_file(uploaded_file)
      basic_file.container = holding_object
      basic_file.save
      basic_file
    end

    def create_basic_file_for_tif(holding_object)
      basic_file = BasicFile.new
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.tif', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      basic_file.add_file(uploaded_file)
      basic_file.container = holding_object
      basic_file.save
      basic_file
    end

    def create_basic_file_for_tif(holding_object, file_name)
      basic_file = BasicFile.new
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: file_name, type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/#{file_name}"))
      basic_file.add_file(uploaded_file)
      basic_file.container = holding_object
      basic_file.save
      basic_file
    end

    def create_tiff_representation(num_of_tiffs)
      tiff_representation = BookTiffRepresentation.new
      tiff_representation.save!

      (1..num_of_tiffs).each { |i|
        tiff_representation.files << create_basic_file_for_tif(tiff_representation, "arre1fm00#{i}.tif")
      }
      tiff_representation.save
      tiff_representation
    end

    def login_admin
      @admin = FactoryGirl.create(:admin)
      controller.stub!(:current_user).and_return(@admin)
    end
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start   'rails'
  end
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.






