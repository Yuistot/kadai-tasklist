class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update]
  before_action :require_user_logged_in
  
  def create
   @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを保存しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクの保存に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def edit
  end
  
  def index
    @tasks = Task.all.page(params[:page])
  end
  
  def update
    
    if @task.update(task_params)
      flash[:success] = 'タスクが正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] ='タスクの更新に失敗しました'
      render :edit
    end
  end
  
  def destroy
    @task = current_user.tasks.find_by(id: params[:id])
    @task.destroy
    
    flash[:success] = 'タスクは正常に破棄されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end