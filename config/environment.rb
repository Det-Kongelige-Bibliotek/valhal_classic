# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

APP_VERSION = `git describe --tags --abbrev=0` unless defined? APP_VERSION

ActionView::Base.field_error_proc = Proc.new {|html, instance| html }

# Initialize the rails application
Valhal::Application.initialize!

