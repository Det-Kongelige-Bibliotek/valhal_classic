# -*- encoding : utf-8 -*-
require 'rubygems'
require 'webmock/rspec'

# Add coverage
if ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start 'rails'
end

# This basic_files is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby basic_files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("app/helpers/**/*.rb")].each {|f| require f}

WebMock.disable_net_connect!(allow_localhost: true)

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
    uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarebo_mets_structmap_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarebo_mets_structmap_sample.xml"))
    basic_file.add_file(uploaded_file, nil)
    basic_file.container = holding_object
    basic_file.save
    basic_file
  end

  def create_basic_file_for_tif(holding_object)
    basic_file = TiffFile.new
    uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.tif', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
    basic_file.add_file(uploaded_file, nil)
    basic_file.container = holding_object
    basic_file.save
    basic_file
  end

  def create_basic_file_for_tif_with_filename(file_name)
    basic_file = TiffFile.new
    uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: file_name, type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/#{file_name}"))
    basic_file.add_file(uploaded_file, nil)
    basic_file
  end

  def create_tiff_instance(num_of_tiffs)
    tiff_instance = OrderedInstance.new

    (1..num_of_tiffs).each { |i|
      tiff_instance.files << create_basic_file_for_tif_with_filename("arre1fm00#{i}.tif")
    }
    tiff_instance.save!
    tiff_instance
  end

  def login_admin
    @admin = FactoryGirl.create(:admin)
    controller.stub(:current_user).and_return(@admin)
  end

  def delete_all_objects
    Work.all.each {|w| w.delete }
    OrderedInstance.all.each {|w| w.delete }
    SingleFileInstance.all.each {|w| w.delete}
    BasicFile.all.each {|w| w.delete }
    Ohm.redis.call('flushdb')
  end

end






