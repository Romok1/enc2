export default function agricultureFormsToQuerystring (forms) {
  const params = {
    agriculture_dashboard: forms.map(form => {
      const {
        country,
        crops_value,
        crops_area_type,
        livestock_value,
        livestock_area_type,
      } = form

      return { // nullify undefined values to tell the querystring builder to send empty properties when undefined
        country: country || null,
        crops_value: crops_value || null,
        crops_area_type: crops_area_type || null,
        livestock_value: livestock_value || null,
        livestock_area_type: livestock_area_type || null,
      }
    })
  }

  if (this.portfolio) {
    params.portfolio = this.portfolio.id
  }

  return this.$qs(params)
}