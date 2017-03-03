CheckAttendence::Engine.routes.draw do
  root :to => 'home#index'
  get 'admin' => 'home#admin'
end

if CheckAttendence.automatic_routes_mount
  Rails.application.routes.draw do
    mount_check_attendence_routes
  end
end
