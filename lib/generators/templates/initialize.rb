module CheckAttendence
  module Ability

    def admin_allowed?
      # authourize admin page
      true
    end

    def check_allowed?
      # authourize check page
      true
    end
  end
end

CheckAttendence.setup do |config|
  #if you use devise, this will work correctly
  #write down your user model name!
  #config.user_model_name = "user"

  #write down main colum name to use it as "username"!
  config.user_model_main_column = "email"

  #home url
  #config.home_url = "/"

  #if you don't want to use default route as /attendence, change as false
  #you can bind route like [get 'my/route' => 'rock_scissors_paper/home#index'] in routes.rb
  #config.automatic_routes_mount = false

  #if you want to use /app/veiws/layouts/application.html.erb, then set this value as true
  #config.use_layout = true

  #if you want to use admin page other layout, then set this value like below
  #config.admin_layout = "admin_application"

  #default model used by CheckAttendence
  config.default_model = <%= model_name.camelize %>

  #if you need to notice playing this game, I recommend put notice written url
  #config.notice_route = "/attendence/notice"

end
