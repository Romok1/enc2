export default {
  escapeRegExp (string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') // $& means the whole matched string
  },

  kebabToCamel (string) {
    let array = string.split('-')
    let camelArray = array.slice(0,1)

    array = array.slice(1).map((string) => {
      return string.substr(0,1).toUpperCase() + string.substr(1)
    })

    camelArray = camelArray.concat(array)

    return camelArray.join('')
  },

  kebabToPascal (string) {
    let array = string.split('-')

    array = array.map((string) => {
      return string.substr(0,1).toUpperCase() + string.substr(1)
    })

    return array.join('')
  },

  removeWhiteSpaces (string) {
    const regex = new RegExp(/\s/g)

    return string.replace(regex, g => { return '' })
  },

  spacesToKebab (string) {
    const regex = new RegExp(/\s/g)

    return string.replace(regex, g => { return '-' })
  },

  trim (string) {
    return string.replace(/^\s+|\s+$/gm,'')
  },

  randomNumber () {
    return Math.floor(Math.random() * 1000) + 1000
  }
}