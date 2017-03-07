CheckAttendence::Engine.routes.draw do
  get 'check' => 'home#index'
  get 'admin' => 'home#admin'
  get 'admin/new' => 'home#admin_form'
  get 'admin/:id' => 'home#admin_r', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  get 'admin/new/:id' => 'home#admin_form', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  post 'admin/create' => 'home#admin_c'
  patch 'admin/update/:id' => 'home#admin_u', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  delete 'admin/destroy/:id' => 'home#admin_d', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
end

if CheckAttendence.automatic_routes_mount
  Rails.application.routes.draw do
    mount_check_attendence_routes
  end
end
