class Admin::CoursesController < AdminController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action do
    authenticate_permissions(['super_admin', 'admin'])
  end

  # GET /admin/courses
  # GET /admin/courses.json
  def index
    if params[:field].present? && params[:keyword].present?
      @courses = Course.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @courses = Course.all.page(params[:page]).per(params[:per])
    end
  end

  # GET /admin/courses/1
  # GET /admin/courses/1.json
  def show
  end

  # GET /admin/courses/new
  def new
    @course = Course.new
  end

  # GET /admin/courses/1/edit
  def edit
  end

  # POST /admin/courses
  # POST /admin/courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to [:admin, @course], notice: t('activerecord.models.course') + '创建成功!' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/courses/1
  # PATCH/PUT /admin/courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to [:admin, @course], notice: t('activerecord.models.course') +'更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/courses/1
  # DELETE /admin/courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to admin_courses_url, notice: t('activerecord.models.course') +'删除成功!' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit!
  end

end