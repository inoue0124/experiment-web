module SessionsHelper
  # 渡されたユーザーでログインする
   def log_in(user)
     session[:user_id] = user.id
   end

   # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if logged_in?
     #@current_user = @current_user || User.find_by(id: session[:user_id])と同じ意味
      @current_user ||= TUser.find_by(id: session[:user_id])
    end
  end

  #受け取ったユーザーがログイン中のユーザーと一致すればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    session[:user_id]
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def getCurrentWorkflow
    @user = current_user

    if @user.done_workflow_id.nil?
      @workflow = TWorkflow.find_by(t_experiment_id: @user[:t_experiment_id])
    else
      @done_wf = TWorkflow.find(@user.done_workflow_id)
      @workflow = TWorkflow.find(@done_wf.next_workflow_id)
    end

    return @workflow
  end
end