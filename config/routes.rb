CheckAttendence::Engine.routes.draw do
  get 'check' => 'home#index'
  get 'admin' => 'home#admin', :as => 'attendence_admin'
  get 'admin/new' => 'home#admin_form'
  get 'admin/:id' => 'home#admin_r', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  get 'admin/new/:id' => 'home#admin_form', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  post 'admin/create' => 'home#admin_c'
  post 'admin/create/:id' => 'home#admin_u', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  delete 'admin/destroy/:id' => 'home#admin_d', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  post 'admin/:list_id/check/new' => 'home#admin_check_new', :constraints => { :list_id => /[0-9]+(\%7C[0-9]+)*/ }
  delete 'admin/check/destroy/:check_id' => 'home#admin_check_destroy', :constraints => { :check_id => /[0-9]+(\%7C[0-9]+)*/ }
end

if CheckAttendence.automatic_routes_mount
  Rails.application.routes.draw do
    mount_check_attendence_routes
  end
end
