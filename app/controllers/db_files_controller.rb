# frozen_string_literal: true

class DbFilesController < ApplicationController
  # This is a superuser method for admins. For students to access their files
  # use submissions#show_file or tests#show_file
  def show
    file = DbFile.find(params[:id])
    send_data(file.contents,
              filename: file.name,
              type: file.content_type)
  end
end
