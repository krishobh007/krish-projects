module SeedEmailTemplateThemes
  def create_email_template_themes
    snt_theme = EmailTemplateTheme.where(is_system_specific: true, name: 'Snt', code: 'snt').first_or_create
  end
end
