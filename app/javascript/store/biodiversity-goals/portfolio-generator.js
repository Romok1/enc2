export const portfolioGenerator = {
  namespaced: true,

  state: {
    forms: [],
    overview: null,
    selectedSector: null,
    selectedTab: 'manual',
  },

  actions: {
    reset ({ commit }) {
      commit('reset')
    },

    updateForms ({ commit }, forms) {
      commit('updateForms', forms)
    },

    updateOverview ({ commit }, overview) {
      commit('updateOverview', overview)
    },

    updateSelectedSector ({ commit }, selectedSector) {
      commit('updateSelectedSector', selectedSector)
    },

    updateSelectedTab ({ commit }, selectedTab) {
      commit('updateSelectedTab', selectedTab)
    }
  },


  mutations: {
    reset (state) {
      state.forms = []
      state.overview = undefined
      state.selectedSector = undefined
      state.selectedTab = 'manual'
    },

    updateForms (state, forms) {
      state.forms = forms
    },

    updateOverview (state, overview) {
      state.overview = overview
    },

    updateSelectedSector (state, selectedSector) {
      state.forms = []
      state.selectedSector = selectedSector
    },

    updateSelectedTab (state, selectedTab) {
      state.selectedTab = selectedTab
    }
  }
}