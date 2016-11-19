class Admin::SuggestionsController < AdminController
  def index
    @suggestions = Suggestion.includes(:user)
      .search(params[:q])
      .order_by_read_and_reccent
      .page(params[:page])
      .per Settings.suggestion_per_page
  end

  def update
    @suggestion = Suggestion.find_by_id params[:id]
    value = !@suggestion.is_read?
    message = t ".fails"
    if @suggestion && @suggestion.update_attribute(:is_read, value)
      message = t ".success"
    end
    respond_to do |format|
      format.json {render json: message.to_json}
    end
  end

  def destroy
    @suggestion = Suggestion.find_by_id params[:id]
    message = t ".fails"
    if @suggestion && @suggestion.destroy
      message = t ".success"
    end
    flash[:info] = message
    redirect_to action: :index
  end
end
