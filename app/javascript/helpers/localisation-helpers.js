export const url = function (url) {
  try {
    const newUrl = new URL(url) // throw on missing scheme

    // does this url originate from this website?
    if (newUrl.origin !== new URL(window.document.URL, window.document.baseURI).origin) {
      return url // don't modify external url
    }
  } catch (_e) {
    // throws when url does not have a scheme
  }

  const replacementUrl = new URL(url, window.document.baseURI)

  replacementUrl.pathname = '/' + this.$i18n.locale
    + replacementUrl.pathname.replace(new RegExp(`^/?${this.$i18n.locale}/`, 'g'), '/') // prevent repetition e.g. /en/en/

  return replacementUrl.toString()
}

export default url