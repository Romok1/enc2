import {
  EXPLORE_FILTERS,
  UNDEFINED_SELECTIONS,
  getCategories,
  getSubIndustriesFromSectors,
  compareAlphabeticallyBy,
  resetDependentSelections
} from '~/helpers/explore-helpers.js'

export const explore = {
  namespaced: true,

  state: {
    filters: EXPLORE_FILTERS,
    selections: UNDEFINED_SELECTIONS,
    sectors: [],
    assets: {
      es: [],
      id: []
    },
    subIndustries: [],
    services: [],
    impactDrivers: [],
    categories: [],
    lastAssetsLocale: {
      es: '',
      id: ''
    },
    lastSectorsLocale: '',
    lastCategoryLocale: '',
    lastImpactDriversLocale: '',
    exploreContentCounts: {},
  },

  mutations: {
    resetDependentSelections(state, { vm, changedDropdownId }) {
      resetDependentSelections(state, { vm, changedDropdownId })
    },

    resetSelections(state) {
      state.selections = UNDEFINED_SELECTIONS
    },

    updateSelections(state, { vm, id, newSelection }) {
      if (newSelection === state.selections[id]) { return }

      state.selections = { ...state.selections, [id]: newSelection }
      resetDependentSelections(state, { vm, changedDropdownId: id })
    },

    updateExploreContentCounts(state, { id, count }) {
      state.exploreContentCounts = {
        ...state.exploreContentCounts, 
        [id]: count
      }
    },

    initializeAssets(state, { vm, includeType }) {
      const hasLoadedCurrentTranslations = state.assets[includeType].length &&
        state.lastAssetsLocale[includeType] === vm.$i18n.locale

      if (!hasLoadedCurrentTranslations) {
        vm.$http
          .get(`/${vm.$i18n.locale}/assets.json?include=${includeType}`)
          .then(res => {
            state.assets[includeType] = res.data.sort(compareAlphabeticallyBy('name'))
            state.lastAssetsLocale[includeType] = vm.$i18n.locale
          })
          .catch(err => {
            console.error(err)
          })
      }
    },

    initializeSectors(state, { vm }) {
      const hasLoadedCurrentTranslations = state.sectors.length &&
        state.lastSectorsLocale === vm.$i18n.locale

      if (!hasLoadedCurrentTranslations) {
        vm.$http
          .get(`/${vm.$i18n.locale}/sectors`)
          .then(res => {
            state.sectors = res.data.sort(compareAlphabeticallyBy('name'))
            state.subIndustries = getSubIndustriesFromSectors(state.sectors)
            state.lastSectorsLocale = vm.$i18n.locale
          })
          .catch(err => {
            console.error(err)
          })
      }
    },

    initializeImpactDrivers(state, { vm }) {
      const hasLoadedCurrentTranslations = state.impactDrivers.length &&
        state.lastImpactDriversLocale === vm.$i18n.locale

      if (!hasLoadedCurrentTranslations) {
        vm.$http
          .get(`/${vm.$i18n.locale}/impact_drivers`)
          .then(res => {
            state.impactDrivers = res.data
            state.lastImpactDriversLocale = vm.$i18n.locale
          })
          .catch(err => {
            console.error(err)
          })
      }
    },

    initializeCategories(state, { vm }) {
      const hasLoadedCurrentTranslations = state.services.length &&
        state.lastCategoriesLocale === vm.$i18n.locale

      if (!hasLoadedCurrentTranslations) {
        vm.$http
          .get(`/${vm.$i18n.locale}/ecosystem_services`)
          .then(res => {
            state.services = res.data
            state.categories = getCategories(state.services)
            state.lastCategoriesLocale = vm.$i18n.locale
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}
