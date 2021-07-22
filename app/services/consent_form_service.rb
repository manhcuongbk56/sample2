class ConsentFormService
  class << self
    
    # owner_type is cb_account or deposit
    def create_accepted_link(owner_id, consent_form_id, owner_type)
      link_class = "#{owner_type.pluralize.camelize}ConsentForm".constantize
      link = link_class.where("#{owner_type}_id": owner_id, consent_form_id: consent_form_id).first
      raise ObjectNotFoundException.new("Object with the id #{owner_id} or #{consent_form_id} does not exist.") unless  link

      link.delete
      link_class.create("#{owner_type}_id": owner_id, consent_form_id: consent_form_id, accept_state: ConsentForm::ACCEPT_STATES[:accepted])
    end

  end
end