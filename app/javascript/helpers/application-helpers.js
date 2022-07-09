export const getAssetIconClass = (assetName) => {
  let className = ''

  switch (assetName) {
  case 'Atmosphere': case 'Atmósfera':
    className = 'atmosphere'
    break
  case 'Habitats': case 'Hábitats':
    className = 'habitats'
    break
  case 'Land geomorphology': case 'Geomorfología del suelo':
    className = 'land'
    break
  case 'Minerals': case 'Minerales':
    className = 'minerals'
    break
  case 'Ocean geomorphology': case 'Geomorfología oceánica':
    className = 'ocean'
    break
  case 'Soils and sediments': case 'Suelos y sedimentos':
    className = 'soil'
    break
  case 'Species': case 'Especies':
    className = 'species'
    break
  case 'Water': case 'Agua':
    className = 'water'
    break
  }

  return `asset-icon--${className}`
}

export const getRatingClass = (rating, localeId) => {
  let className

  switch (rating.trim()) {
  case 'VH':
    className = 'indicator--v-high'
    break
  case 'H':
    className = 'indicator--high'
    break
  case 'M':
    className = 'indicator--medium'
    break
  case 'L':
    className = 'indicator--low'
    break
  case 'VL':
    className = 'indicator--v-low'
    break
  default:
    className = 'indicator--unknown'
    break
  }

  const classes = [className, 'indicator--circle']

  if (localeId !== 'en') {
    classes.push(className + '--' + localeId)
  }

  return classes
}

export const ratingHasEntities = rating => {
  return rating.entities && rating.entities.length
}
