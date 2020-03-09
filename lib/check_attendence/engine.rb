module CheckAttendence
  include Devise::Controllers::Helpers::ClassMethods
  class Engine < ::Rails::Engine
    isolate_namespace CheckAttendence
    config.autoload_paths += Dir["#{config.root}/lib"]

    initializer 'check_attendence.assets.precompile', :group => :all do |app|
      app.config.assets.precompile += ['check_attendence_manifest.js']
    end
  end
end
