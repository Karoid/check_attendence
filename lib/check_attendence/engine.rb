module CheckAttendence
  include Devise::Controllers::Helpers::ClassMethods
  class Engine < ::Rails::Engine
    isolate_namespace CheckAttendence
    config.autoload_paths += Dir["#{config.root}/lib"]

    initializer 'any_login.assets_precompile', :group => :all do |app|
      app.config.assets.precompile += ['check_attendence/*']
    end
  end
end
