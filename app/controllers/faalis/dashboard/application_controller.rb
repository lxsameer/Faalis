require 'ostruct'

module Faalis
  module Dashboard
    class ApplicationController < Faalis::ApplicationController
      layout 'faalis/dashboard'

      before_action :setup_sidebar
      before_action :setup_header

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_404

      private

        def setup_sidebar

          user = OpenStruct.new(title: _('Users'),
                                url: dashboard_auth_users_path)

          group = OpenStruct.new(title: _('Groups'),
                                 url: dashboard_auth_groups_path)

          auth = OpenStruct.new(icon: 'fa fa-group',
                                title: _('Authentication'),
                                children: [user, group])

          @sidebar = OpenStruct.new(menu_entries: [auth])
        end

        def setup_header
          @dashboard_section_title = _(controller_name).humanize
          @dashboard_section_slug  = _(action_name).humanize
        end

        def user_not_authorized
          flash[:alert] = _('You are not authorized to perform this action.')
          redirect_to new_user_session_path
        end

        def redirect_to_404(e)
          respond_to do |f|
            f.html { redirect_to dashboard_not_found_url }
            f.js { render 'faalis/dashboard/not_found' }
          end
        end
    end
  end
end
