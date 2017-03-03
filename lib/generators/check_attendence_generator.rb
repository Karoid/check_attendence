module CheckAttendence
  module Generators
    class CheckAttendenceGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :model_name, :type => :string, :default => "attendence"
      hook_for :orm
      def generate_check_attendence
        template 'initialize.rb', 'config/initializers/check_attendence.rb'
      end
    end
  end
end
