import Qs from 'qs'
import { IMPACTS_ID } from '~/helpers/explore-helpers'

export const getMapURLByServiceId = id => id ? `/map?id=${id}` : '/map'

export const getImpactsMapURl = () => `/map?view=${IMPACTS_ID}`

export const getMapURLByView = view => `/map?view=${view}`

export const getAssetPath = id => `/assets/${id}`

export const getEcosystemServicePath = id => `/ecosystem_services/${id}`

export const getImpactDriverPath = id => `/impact_drivers/${id}`

export const getCountriesPath = () => '/countries'

export const getAgricultureCountriesPath = () => '/countries/agriculture_countries'

export const getDashboardPath = bioModule => `/tools/biodiversity-goals/${bioModule}-dashboard`

export const getFetchDashboardPdfPath = (bioModule, jobId) => `${getDashboardPath(bioModule)}/fetch_pdf/${jobId}`

export const getAlignmentOptionsQueryString = ({selectedOptionIds, moduleName=null, paramsNestingKey=null}) => {
  const params = moduleName ? { biodiversity_module: moduleName } : {}

  for (const [key, value] of Object.entries(selectedOptionIds)) {
    params[key] = [... value]
  }

  const nestedParams = paramsNestingKey ? { [paramsNestingKey]: params } : params

  const queryString = Qs.stringify(nestedParams, {
    arrayFormat: 'brackets',
    encode: false
  })

  return queryString
}

export const downloadPdf = (url) => {
  const link = document.createElement('a')

  link.href = url
  link.download = true
  link.click()
}