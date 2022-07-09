export const dashboard = {
  namespaced: true,

  state: {
    areaTypes: [
      'area',
      'turnover'
    ],

    cropTypes: [
      'crops',
      'livestock'
    ],

    busy: false,
  
    alignmentOptionSelections: {},
    biodiversityModule: null
  },

  getters: {
    areaTypes: state => {
      return state.areaTypes
    },

    cropTypes: state => {
      return state.cropTypes
    },
  },

  actions: {
    reset ({ commit }) {
      commit('reset')
    },

    updateAlignmentOptionSelections ({ commit }, selections) {
      commit('updateAlignmentOptionSelections', selections)
    },

    updateBiodiversityModule ({ commit }, moduleName) {
      commit('updateBiodiversityModule', moduleName)
    }
  },

  mutations: {
    reset (state) {
      state.busy = false
      state.alignmentOptionSelections = {}
      state.biodiversityModule = undefined
    },

    updateAlignmentOptionSelections (state, selections) {
      state.alignmentOptionSelections = {...selections}
    },

    updateBiodiversityModule (state, moduleName) {
      state.biodiversityModule = moduleName
    }
  } 
}