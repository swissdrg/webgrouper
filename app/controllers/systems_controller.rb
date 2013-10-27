require 'fileutils'

class SystemsController < ApplicationController

  # Used by the drg-dev tool to create systems for internal use only.
  # Should not be present in public version!
  def create
    s = System.new(params[:system])
    if System.where(:description => s.description).exists?
      render :json => {:text => 'System schon vorhanden',
                       :system_id => System.where(:description => s.description).first.system_id }
    else
      s.public = true
      s.save
      status = 500
      if s.errors.any?
        notice = s.errors.full_messages.join("\n")
      else
        begin
          s.compile_64bit_spec(params[:spec_files])
          notice = 'System erfolgreich hinzugefuegt'
          status = 200
        rescue Exception => e
          raise e if Rails.env == 'development'
          notice = 'Konnte System nicht erstellen: ' + e.message
          s.destroy
        end
      end
      render :json => {:text => notice, :system_id => s.system_id}, :status => status
    end
  end

end