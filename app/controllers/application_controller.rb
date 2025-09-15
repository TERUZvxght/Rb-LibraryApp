class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :is_admin?

  private
    def require_admin
      unless current_user&.admin?
        redirect_to books_path, alert: "管理者権限が必要です。"
      end
    end

    def is_admin?
      current_user&.admin?
    end
end
