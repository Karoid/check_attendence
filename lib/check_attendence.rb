require "rails"

module CheckAttendence
    # automatic engine routes mouting
    mattr_accessor :automatic_routes_mount
    @@automatic_routes_mount = true

    mattr_accessor :user_model_name
    @@user_model_name = 'user'

    mattr_accessor :user_model_main_column
    @@user_model_main_column = "email"

    mattr_accessor :home_url
    @@home_url = "/"

    mattr_accessor :use_layout
    @@use_layout = false

    mattr_accessor :admin_layout
    @@admin_layout = nil

    mattr_accessor :default_model

    mattr_accessor :notice_route
    @@notice_route = nil

    def self.use_default_configuration!
      self.automatic_routes_mount             = true
      self.enabled                            = true
    end

    # Default way to set up Devise. Run rails generate devise_install to create
    # a fresh initializer with all configuration values.
    def self.setup
      yield self
    end

end
require_relative "check_attendence/rails/routes"
require "check_attendence/ability"
require "check_attendence/version"
require "check_attendence/engine"
