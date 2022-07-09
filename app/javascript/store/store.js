import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'
import { biodiversityGoals } from './biodiversity-goals'
import { explore } from './explore'
import { naturalCapital } from './natural-capital'
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    portfolio: undefined,
    user: undefined
  },

  modules: {
    biodiversityGoals,
    explore: explore,
    naturalCapital,
  },

  actions: {
    updatePortfolio ({ commit }, portfolio) {
      commit('updatePortfolio', portfolio)
    },

    updateUser ({ commit }, user) {
      commit('updateUser', user)
    }
  },

  mutations: {
    updatePortfolio (state, portfolio) {
      state.portfolio = portfolio
    },

    updateUser (state, user) {
      state.user = user
    }
  }
})
