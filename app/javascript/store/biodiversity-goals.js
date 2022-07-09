import { dashboard } from './biodiversity-goals/dashboard'
import { portfolioGenerator } from './biodiversity-goals/portfolio-generator'

export const biodiversityGoals = {
  namespaced: true,

  modules: {
    dashboard,
    portfolioGenerator,
  },

  actions: {
    reset ({ dispatch }) {
      dispatch('dashboard/reset')
      dispatch('portfolioGenerator/reset')
    }
  }
}