class TasksController < ApplicationController
  include JsonWebToken
  before_action :jwt_authenticate

  def index
    render status: 200, json: {status: 200, tasks: @current_user.tasks}
  end

  def create
    new_task = @current_user.tasks.build(task_params)
    if new_task.save
      render status: 200, json: {status: 200, new_task: new_task}
    else
      render status: 400, json: {status: 400, msg: "Create task failed."}
    end
  end

  def task_params
    params.require(:task).permit(:text, :selected_date)
  end

end
