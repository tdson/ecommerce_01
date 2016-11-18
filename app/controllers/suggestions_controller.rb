class SuggestionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @suggestion = Suggestion.new
  end

  def create
    suggestion = current_user.suggestions.create suggestion_params
    @suggestion = Suggestion.new
    if suggestion.save
      flash[:success] = t ".success"
      redirect_to action: :new
    else
      render :new
    end
  end

  private
  def suggestion_params
    params.require(:suggestion).permit :content
  end
end
