module CheckAttendence
  if CheckAttendence.use_layout
    HomeController = Class.new(::ApplicationController)
  else
    HomeController = Class.new(ApplicationController)
  end

  class HomeController
    include CheckAttendence::Ability
    layout CheckAttendence.admin_layout, only: [:admin, :admin_form, :admin_r] if CheckAttendence.admin_layout

    def index
      return not_allowed unless check_allowed?
      if params[:code]
        @current_user = current_user
        @my_record_list = attendence_list_model.where(code: params[:code]).take
        if @my_record_list
          # code exist
          if @my_record_list.start < Time.now && @my_record_list.end >= Time.now
            #code is not expired
            @my_data = {attendence_list_id: @my_record_list.id, user_id: current_user.id, user_name: current_user_name}
            check_attendence_if_not(@my_data, @my_record_list.name)
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
      return not_allowed unless admin_allowed?
      @article_page = attendence_list_model.where("name LIKE ?", "%#{params[:search]}%")
      .paginate(:page => params[:page], :per_page => 5).order('id DESC')
      #Json 요청으로 목록 받아올때
      if params[:json]
        respond_to do |format|
          format.json { render json: make_object_to_json(@article_page) }
        end
      end
    end

    def admin_form
      return not_allowed unless admin_allowed?
      @modify = attendence_list_model.find(params[:id]) if params[:id]
    end

    def admin_c
      return not_allowed unless admin_allowed?
      respond_to do |format|
        @attendence_list = attendence_list_model.new(attendence_list_params)
        if @attendence_list.save
          format.html {redirect_to check_attendence_path + '/admin/' + @attendence_list.id.to_s}
          format.json {render json: {:success => true}}
        end
      end
    end

    def admin_r
      return not_allowed unless admin_allowed?
      @attendence_list = attendence_list_model.find(params[:id])
      @attendence = attendence_model.where(attendence_list_id: params[:id]).paginate(:page => params[:page], :per_page => 5).order('id DESC')
      if params[:json]
        respond_to do |format|
          format.json { render json: make_object_to_json(@attendence) }
        end
      end

      if params[:download]
        @attendence_download = attendence_model.where(attendence_list_id: params[:id])
        csv_string = CSV.generate do |csv|
          csv << ["Attendence List Data"]
          csv << @attendence_list.attributes.keys
          csv << @attendence_list.attributes.values
          csv << []
          csv << []
          csv << ["Attendence Data"]
          @attendence_download[0] ? csv << @attendence_download[0].attributes.keys : nil
          @attendence_download.each do |x|
            csv << x.attributes.values
          end
        end

        send_data(
          csv_string.encode("EUC-KR"),
          filename: "#{@attendence_list.name}.csv",
          type: "text/csv; charset=EUC-KR; header=present"
        )
      end
    end

    def admin_u
      return not_allowed unless admin_allowed?
      respond_to do |format|
        @attendence_list = attendence_list_model.find(params[:id])
        if @attendence_list.update(attendence_list_params)
          format.html {redirect_to check_attendence_path + '/admin/' + @attendence_list.id.to_s}
          format.json {render json: {:end => @attendence_list.end, :start => @attendence_list.start}}
        end
      end
    end

    def admin_d
      return not_allowed unless admin_allowed?
      @attendence_list = attendence_list_model.find(params[:id]).destroy
      @attendence = attendence_model.where(attendence_list_id: params[:id]).destroy_all
      render json: {:success=>true}
    end

    def admin_check_new
      return not_allowed unless admin_allowed?
      records = CheckAttendence.user_model_name.capitalize.constantize
      .where(CheckAttendence.user_model_main_column => params[:user_name])
      if records.count >= 1
        user_id = records.take.id
      else
        user_id = nil
      end

      check_attendence_if_not({attendence_list_id: params[:list_id], user_id: user_id, user_name: params[:user_name]})
    end

    def admin_check_destroy
      return not_allowed unless admin_allowed?
      attendence_model.find(params[:check_id]).destroy
      render json: {:success=>true}
    end

    private

    def check_attendence_if_not(data, respond_msg = nil)
      if attendence_model.where(data).length > 0
        #already checked attendence
        render json: {:respond => "이미 출석체크 하셨습니다", :warn => true}
      else
        if (save = attendence_model.create(data))
          render json: {:respond => respond_msg, :id => save.id}
        else
          render json: {:respond => "저장에 오류가 있습니다", :err => true}
        end
      end
    end

    def attendence_list_params
      params[:attendence_list][:user_id] = current_user.id
      params[:attendence_list][:user_name] = current_user_name
      params[:attendence_list][:start] = Time.now + params[:time_start].to_i
      params[:attendence_list][:end] = Time.now + params[:time_end].to_i
      params[:attendence_list][:code] = params[:attendence_list][:code] || Random.rand(1000..9999)
      params.require(:attendence_list).permit(:name,:user_name,:user_id,:code,:start,:end)
    end

    def make_object_to_json(object)
      #AJAX를 위해 view 담기
      @article_page_json = []
      object.each do |value|
        hash = {}
        hash = value.attributes
        hash[:view] = (attendence_model).where(attendence_list_id: value.id).count
        @article_page_json.push(hash)
      end
      return @article_page_json
    end

    def current_user
      send('current_'+CheckAttendence.user_model_name)
    end

    def current_user_name
      current_user[CheckAttendence.user_model_main_column]
    end

    def attendence_list_model
      (CheckAttendence.default_model.to_s+"List").constantize
    end
    def attendence_model
      CheckAttendence.default_model
    end

    # Method, which called when user tries to visit
    def not_allowed
      flash[:alert] = "Not authourized"
      begin
        redirect_to :back
      rescue
        redirect_to CheckAttendence.home_url
      end
    end
  end
end
