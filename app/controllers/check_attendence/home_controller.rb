module CheckAttendence
  if CheckAttendence.use_layout
    HomeController = Class.new(::ApplicationController)
  else
    HomeController = Class.new(ApplicationController)
  end

  class HomeController
    before_action 'authenticate_'+CheckAttendence.user_model_name+'!'
    def index
      if params[:code]
        @current_user = send('current_'+CheckAttendence.user_model_name)
        @my_record_list = (CheckAttendence.default_model.to_s+"List").constantize.where(code: params[:code]).take
        if @my_record_list
          @my_record = (CheckAttendence.default_model).create(attendence_list_id: @my_record_list.id, user_id: @current_user.id)
          render json: {:respond => @my_record_list.name}
        else
          render json: {:respond => "잘못 입력하셨습니다", :err => true}
        end
      end
    end



  end
end
