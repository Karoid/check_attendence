module CheckAttendence
  if CheckAttendence.use_layout
    HomeController = Class.new(::ApplicationController)
  else
    HomeController = Class.new(ApplicationController)
  end

  class HomeController
    before_action 'authenticate_'+CheckAttendence.user_model_name+'!'
    layout CheckAttendence.admin_layout, only: [:admin, :admin_form, :admin_r]
    def index
      if params[:code]
        @current_user = send('current_'+CheckAttendence.user_model_name)
        @my_record_list = (CheckAttendence.default_model.to_s+"List").constantize.where(code: params[:code]).take
        if @my_record_list
          # code exist
          if @my_record_list.start < Time.now && @my_record_list.end >= Time.now
            #code is not expired
            @my_record = (CheckAttendence.default_model).where(attendence_list_id: @my_record_list.id, user_id: send('current_'+CheckAttendence.user_model_name).id)
            if @my_record.length > 0
              #already checked attendence
              render json: {:respond => "이미 출석체크 하셨습니다", :warn => true}
            else
              #check attendence
              @my_record.create(user_id: @current_user.id)
              render json: {:respond => @my_record_list.name}
            end
          else
            #code is expired
            render json: {:respond => "기한이 만료되었습니다", :err => true}
          end
        else
          #code dosen't exist
          render json: {:respond => "잘못 입력하셨습니다", :err => true}
        end
      end
    end

    def admin
      @article_page = (CheckAttendence.default_model.to_s+"List").constantize.where("name LIKE ?", "%#{params[:search]}%")
      .paginate(:page => params[:page], :per_page => 5).order('id DESC')
      #Json 요청으로 목록 받아올때
      if params[:json]
        respond_to do |format|
          format.json { render json: make_object_to_json(@article_page) }
        end
      end
    end

    def admin_form

    end

    def admin_c
      respond_to do |format|
        @attendence_list = (CheckAttendence.default_model.to_s+"List").constantize.new(attendence_list_params)
        if @attendence_list.save
          format.html {redirect_to check_attendence_path + '/admin/' + @attendence_list.id.to_s}
          format.json {render json: {:success => true}}
        end
      end
    end

    def admin_r
      @attendence_list = (CheckAttendence.default_model.to_s+"List").constantize.find(params[:id])
      @attendence = CheckAttendence.default_model.where(attendence_list_id: params[:id]).paginate(:page => params[:page], :per_page => 5).order('id DESC')
      if params[:json]
        respond_to do |format|
          format.json { render json: make_object_to_json(@attendence) }
        end
      end
    end

    def admin_u
      respond_to do |format|
        @attendence_list = (CheckAttendence.default_model.to_s+"List").constantize.find(params[:id])
        if @attendence_list.update(attendence_list_params)
          format.html {redirect_to check_attendence_path + '/admin/' + @attendence_list.id}
          format.json {render json: {:end => @attendence_list.end, :start => @attendence_list.start}}
        end
      end
    end

    def admin_d
      @attendence_list = (CheckAttendence.default_model.to_s+"List").constantize.find(params[:id])
      @attendence = CheckAttendence.default_model.where(attendence_list_id: params[:id])
    end

    private

    def attendence_list_params
      params[:attendence_list][:user_id] = send('current_'+CheckAttendence.user_model_name).id
      params[:attendence_list][:start] = Time.now + params[:time_start].to_i
      params[:attendence_list][:end] = Time.now + params[:time_end].to_i
      params[:attendence_list][:code] = params[:attendence_list][:code] || Random.rand(1000..9999)
      params.require(:attendence_list).permit(:name,:user_id,:code,:start,:end)
    end

    def admin_layout
      if CheckAttendence.admin_layout
        render layout: CheckAttendence.admin_layout
      end
    end


    private
    def make_object_to_json(object)
      #AJAX를 위해 view 담기
      @article_page_json = []
      object.each do |value|
        hash = {}
        hash = value.attributes
        @this_record = CheckAttendence.user_model_name.capitalize.constantize.find(value.user_id)
        hash[:user] = @this_record.username || @this_record.email
        hash[:view] = (CheckAttendence.default_model).where(attendence_list_id: value.id).count
        @article_page_json.push(hash)
      end
      return @article_page_json
    end
  end
end
