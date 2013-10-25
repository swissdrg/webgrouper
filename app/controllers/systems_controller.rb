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
        if params[:spec_file]
          path = File.join(spec_folder, s.system_id.to_s, 'Spec64bit.bin')
          FileUtils.mkdir(File.dirname(path))
          File.open(path, 'wb') { |f| f.write(params[:spec_file].read) }
          notice = 'System erfolgreich hinzugefuegt'
          status = 200
        else
          notice = 'Kein Spezifikationsfile angehaengt, konnte nicht speichern'
          s.destroy
        end
      end
      render :json => {:text => notice, :system_id => s.system_id}, :status => status
    end
  end

end