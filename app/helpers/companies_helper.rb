module CompaniesHelper
  def company_from_id(id, companies)
    whole_sector = {
      id: 'whole_sector',
      name: I18n.t('biodiversity_goals.portfolio.forms.mining.unset_company_name')
    }

    id.blank? ? whole_sector : companies.find(id)
  end
end
