const BLANK_SELECTIONS = {
  sub_industry_ids: [],
  production_process_ids: []
}

export const dashboard = {
  namespaced: true,

  state: {
    busy: false,
    selections: BLANK_SELECTIONS,
  },

  actions: {
    reset ({ commit }) {
      commit('reset')
    },

    updateSelections ({ commit }, updatedSelections) {
      commit('updateSelections', updatedSelections)
    }
  },

  mutations: {
    reset (state) {
      state.busy = false
      state.selections = { ...BLANK_SELECTIONS }
    },

    /**
     * updateSelections updates both sub-industries and production processes at the same time 
     * avoiding triggering watchers twice when a portfolio is loaded or sub-industry updated.
     */
    updateSelections (state, updatedSelections) {
      state.selections = { ...state.selections, ...updatedSelections }
    }
  }
}