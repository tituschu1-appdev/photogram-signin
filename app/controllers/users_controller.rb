class UsersController < ApplicationController

  def authenticate
    # get username from params
    # get password form params
    # Parameters: {"input_username"=>"titus", "input_password"=>"[FILTERED]"}

    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    # look up record from db matching  for username
    user = User.where({ :username => un}).at(0)

    # if no record redirect to sign in
    if user == nil
      redirect_to("/user_sign_in", { :alert => "No one by that name 'round these parts!"})
    else
      # if there is record, check if password matches
      # if not redirect to sign in
      # if password matches, set cookie
      # take to home page
      if user.authenticate(pw)
        session.store( :user_id, user.id)

        redirect_to("/", { :notice => "Welcome Back " + user.username + "!"})
      else
        redirect_to("/user_sign_in", { :alert => "Nice try, sucker!"})
      end
    end
  end

  def toast_cookies
    reset_session

    redirect_to("/", {:notice => "See ya later!"})
  end

  def new_registration_form


    render({ :template => "users/signup_form.html" })
  end

  def new_session_form


    render({ :template => "users/signin_form.html" })
  end

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
        session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", {:notice => "Welcome, " + user.username + "!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
