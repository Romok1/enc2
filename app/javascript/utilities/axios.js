import axios from 'axios'

axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'


/**
 * Register the CSRF Token as a common header with Axios so that
 * all outgoing HTTP requests automatically have it attached,
 * and it doesn't need to be done manually for every token.
 */

const token = document.head.querySelector('meta[name="csrf-token"]')

if (token) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content
} else {
  console.error('CSRF token not found')
}

/**
 * PDF generation happens in a headless chromium instance
 * therefore we need to authenticate using a token and pass
 * the user_id as there is a new session
 */

axios.defaults.params = {}
const DEFAULT_PARAMS_FOR_PDF = ['auth_token', 'user_id']
const url = new URL(window.location.href)

DEFAULT_PARAMS_FOR_PDF.forEach(key => {
  const value = url.searchParams.has(key)  ? url.searchParams.get(key) : undefined

  if (value) {
    axios.defaults.params[key] = value
  }
})

export default axios