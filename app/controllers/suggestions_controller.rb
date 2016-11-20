class SuggestionsController < ApplicationController
  before_action :authenticate_user!
  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new suggestion_params
    if @suggestion.save
      flash[:success] = t "suggestions.create_success"
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def suggestion_params
    params.require(:suggestion).permit :user_id, :content
  end
end
