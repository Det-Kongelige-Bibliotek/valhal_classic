# This basic_files is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Valhal::Application
