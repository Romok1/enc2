import { dashboard } from './natural-capital/dashboard'

export const naturalCapital = {
  namespaced: true,

  modules: {
    dashboard,
  },

  actions: {
    reset ({ dispatch }) {
      dispatch('dashboard/reset')
    }
  }
}