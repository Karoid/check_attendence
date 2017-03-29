module CheckAttendence
  module Ability

    def admin_allowed?
      # default authourization of admin page
      true
    end

    def check_allowed?
      # default authourization of check page
      true
    end

  end
end
