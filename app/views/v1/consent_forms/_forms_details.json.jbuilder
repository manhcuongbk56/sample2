json.consent_forms consent_form_links do |link|
  json.extract! link.consent_form, :id, :name, :version, :required_for, :full_text
  json.status link.accept_state
end