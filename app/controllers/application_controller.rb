class ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  private

  def render_error(error_message, status)
    render json: { error: error_message }, status: status
  end

  def limit_per_page(max_per_page)
    per_page = params[:per_page]
    per_page = max_per_page if per_page.to_i > max_per_page
    per_page || max_per_page
  end

  def extract_pagination_from!(collection = [], default: 20)
    if collection.respond_to?(:total_pages)
      response.headers["x-per-page"] = collection.per_page
      response.headers["x-current-page"] = collection.current_page
      response.headers["x-total-pages"] = collection.total_pages
    else
      response.headers["x-per-page"] = params.fetch(:per_page) { default }
      response.headers["x-current-page"] = 1
      response.headers["x-total-pages"] = 1
    end
  end
end
