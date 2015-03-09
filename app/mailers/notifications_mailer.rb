class NotificationsMailer < ActionMailer::Base
  default from: SETTINGS[:confirmation_email]

  def new_org_created(organization)
    @organization = organization
    admins = Admin.where(super_admin: true).pluck(:email)
    mail :to => SETTINGS[:admin_support_email], :cc => admins, :subject => "New organisation on Clacks-Ohana"
  end

end
