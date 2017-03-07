module ActionDispatch::Routing
  class Mapper
    def mount_check_attendence_routes(options = {})
      mount CheckAttendence::Engine => '/attendence', :as => options[:as] || 'check_attendence'
    end
  end
end
