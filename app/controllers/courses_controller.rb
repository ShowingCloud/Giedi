class CoursesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload_opus]
  before_action :authenticate_user!, except: [:index]

  def index
    @courses = Course.where(course_type: 1, status: 1).select(:id, :name, :cover, :author).page(params[:page]).per(params[:per])
  end

  def show
    course_id = params[:id]
    course = Course.find(course_id)
    if course && course.status != 0
      if course.course_type == 0
        @course = Course.joins(:group_course_ships).joins('left join group_user_ships g_u on g_u.group_id = group_course_ships.group_id').where(id: course_id).where('g_u.user_id=?', current_user.id).select(:id, :name, :cover, :status, :course_type, :course_info, 'group_course_ships.group_id', 'g_u.status as apply_status').take
        if @course
          if @course.apply_status == 1
            @lessons = Lesson.where(course_id: course_id).includes(:photos)
            @stars = course.course_stars.select(:name, :stars)
          else
            @course.status = -1 # 还未审核
          end
        else
          redirect_to '/courses/dome'
        end
      else
        @course = course
      end
    else
      render_optional_error(404)
    end
  end

  def dome
    current_user_id = current_user.id
    @group_user = Group.joins(:group_user_ships).left_joins(:teacher).where('group_user_ships.user_id = ?', current_user_id).where('groups.end_date > ?', Date.today).select('group_user_ships.status as ship_status', 'groups.*', 'admins.name as teacher_name', 'admins.avatar').take
    if @group_user.present?
      @sign_in = current_user.sign_in
      @group_courses = @group_user.courses.select(:id, :name, :cover)
      average_right = current_user.user_lesson_tests.where('created_at > ?', @group_user.start_date).average(:right_percent)
      progress = GroupSchedule.find_by_sql("select count(a.id) as all_num,(select count(a.id) from group_schedules a where a.start < '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}') as already_num from group_schedules a where a.group_id = #{@group_user.id}").first
      @progress = {average_right: average_right.present? ? average_right.round(2) : 0, already_num: progress.already_num, all_num: progress.all_num, progress: (progress.all_num > 0) ? ((Float(progress.already_num)/progress.all_num)*100).round(0) : 0}
    else
      @groups = Group.where(status: 1).select(:id, :name)
    end
  end


  def apply_group
    group_id = params[:user][:select_group]
    username = params[:user][:fullname]
    student_code = params[:user][:student_code]
    current_user_id = current_user.id
    if group_id.present? && username.present? && student_code.present?
      group = Group.find(group_id)
      if group && (group.end_date > Time.now)
        if GroupUserShip.where(user_id: current_user_id, group_id: group_id).exists?
          flash[:error] = '您已是该班级学生,无需再次申请'
        else
          if current_user.update(fullname: username, student_code: student_code)
            g_u = GroupUserShip.create(user_id: current_user_id, group_id: group_id, status: 0)
            if g_u.save
              flash[:success] = '申请成功,审核结果将通过消息推送告知您!'
            else
              flash[:error] = '申请失败!'
            end
          else
            flash[:error] = '参数不规范'
          end
        end
      else
        flash[:error] = '该班级已结业 或 不规范操作'
      end
    else
      flash[:error] = '请将班级、姓名、学籍号填写完整'
    end
    redirect_to '/courses/dome'
  end

  def schedule
    group_id = params[:id]
    if group_id.present? && GroupUserShip.where(group_id: group_id, user_id: current_user.id).exists?
      @group = Group.find(group_id)
      @group_schedules = @group.group_schedules
    else
      render_optional_error(404)
    end
  end

  def sign_in
    current_user_id = current_user.id
    sign_in = SignIn.find_by_user_id(current_user_id)
    if sign_in
      time_now = Time.now
      today_dawn = time_now.midnight
      sign_in_update_at = sign_in.updated_at

      if sign_in_update_at > today_dawn
        @result = [false, '今天你已签到']
      else
        if sign_in_update_at > (today_dawn-1.day)
          sign_in.continuous_days += 1
        end
        sign_in.updated_at = time_now
        sign_in.sign_count += 1
        if sign_in.save
          @result = [true, '签到成功']
        else
          @result = [false, '签到失败']
        end
      end
    else
      new_sign_in = SignIn.create(user_id: current_user_id)
      if new_sign_in.save
        @result = [true, '签到成功']
      else
        @result = [false, '签到失败']
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def lesson_test
    lesson_id = params[:id]
    check_ability = check_group_user(lesson_id)
    if lesson_id.present? && check_ability.present?
      @tests = LessonTest.where(lesson_id: lesson_id).order(:id)
      @has_test = current_user.user_lesson_tests.find_by(lesson_id: lesson_id)
      @belong_name = Lesson.joins(:course).where(id: lesson_id).select(:name, 'courses.name as course_name').take
    else
      render_optional_error(403)
    end
  end

  def check_lesson_test
    lesson_id = params[:lesson_id]
    answers = params[:answers]


    if lesson_id && answers.to_unsafe_h.is_a?(Hash)
      check_ability = check_group_user(lesson_id)
      if check_ability.present?
        if current_user.user_lesson_tests.where(lesson_id: lesson_id).exists?
          result = [false, '您已做过该测试']
        else
          tests = LessonTest.where(lesson_id: lesson_id)
          test_keys = tests.pluck(:id).map { |x| x.to_s }
          answers_keys = answers.keys
          if (test_keys & answers_keys).count == test_keys.length
            right_per = []
            answer_result = {}
            tests.each do |test|
              the_answer = answers["#{test.id}"].to_a
              status = (test.answer & the_answer).count == the_answer.length ? 1 : 0
              right_per << true if status == 1
              answer_result[test.name] = status
            end
            right_percent = (((Float(right_per.length)/tests.length))*100).round(2)
            teacher_avatar = Admin.joins(:groups).where('groups.id = ?', check_ability.group_id).select(:id, :teacher_avatar).map { |a| {
                id: a.id,
                avatar: a.teacher_avatar.present? ? ActionController::Base.helpers.asset_path(a.teacher_avatar[right_percent == 100.0 ? 0 : 1].url(:middle)) : nil
            } }
            user_lesson_test = current_user.user_lesson_tests.create(lesson_id: lesson_id, right_percent: right_percent, answer_result: answer_result, group_id: check_ability.group_id)
            if user_lesson_test.save
              result = [true, {right_per: right_percent, teacher_avatar: teacher_avatar[0][:avatar]}]
            else
              result = [false, '答题失败']
            end
          else
            result = [false, '答案不完整']
          end
        end
      else
        result = [false, '403']
      end
    else
      result = [false, '参数不完整']
    end
    render json: result
  end

  def community
    group_id = params[:id]
    @group = Group.find(group_id)
    @group_opus = @group.group_opus.includes(:user).where(status: 1).order('likes_count desc').page(params[:page]).per(params[:per])
  end

  def discuss
    group_id = params[:id]
    @group = Group.find(group_id)
    @comments = GroupCommunity.includes(:user, :child_group_communities).where(group_id: group_id).where('parent_id is ?', nil)
  end

  def discuss_post
    g_c_params = params[:group_community]
    group_id = g_c_params[:group_id]
    parent_id = g_c_params[:parent_id]
    content = g_c_params[:content]
    anonymous = g_c_params[:anonymous]
    group_community = GroupCommunity.create(group_id: group_id, user_id: current_user.id, parent_id: parent_id, content: content, anonymous: anonymous)
    if group_community.save
      flash[:notice] = '提交成功'
    else
      flash[:error] = group_community.errors.full_messages.first
    end

    redirect_to "/courses/discuss/#{group_id}"
  end

  def upload_opus
    group_opus = params[:group_opu]
    group_id = group_opus[:group_id]
    course_id = group_opus[:course_id]
    content = group_opus[:content]
    current_user_id = current_user.id
    if group_id.present? && content.present?
      group_user = GroupUserShip.where(user_id: current_user_id, group_id: group_id).exists?
      if group_user
        g_o = GroupOpu.create(course_id: course_id, group_id: group_id, content: content, user_id: current_user.id)
        if g_o.save
          @message = '上传成功,审核通过后会显示'
        else
          @message = '上传失败'
        end
      else
        @message = '您没有权限上传'
      end
    else
      @message = '参数不完整'
    end
    render json: {message: @message}
  end

  def lesson_ware
    lesson_id = params[:id]
    if check_group_user(lesson_id)
      @name = Lesson.joins(:course).where(id: lesson_id).select(:name, 'courses.name as course_name').take!
      @lesson_wares = Photo.where(photo_type: 1, type_id: lesson_id).order('sort asc')
    else
      render_optional_error(403)
    end
  end

  private

  def check_group_user(lesson_id)
    GroupCourseShip.left_j_lesson.left_j_group_user.where('l.id=?', lesson_id).where('g_u.user_id=?', current_user.id).select(:id, :group_id, :course_id).take
  end
end
