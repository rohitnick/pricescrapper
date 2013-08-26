class ApplicationController < ActionController::Base
  protect_from_forgery

  def getPage(link)
      mech = Mechanize.new
      ca_path = File.expand_path "#{Rails.root}/app/assets/cacert.pem"
      mech.agent.http.ca_file = ca_path
      return mech.get(link)
  end
end
