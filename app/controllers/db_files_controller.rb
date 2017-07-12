class DbFilesController < ApplicationController
  skip_before_action :check_admin

  def show
    if !current_user_owns_file(params[:id].to_i)
      head :forbidden
      return
    end

    file = DbFile.find(params[:id])
    send_data(file.contents,
              filename: file.name,
              type: file.content_type)
  end

  private

  def current_user_owns_file(file_id)
    owned_file_ids = Set.new(current_user.submissions.pluck(:db_file_id))
        .merge(current_user.tests.pluck(:db_file_id))
    owned_file_ids.include? file_id
  end
end
