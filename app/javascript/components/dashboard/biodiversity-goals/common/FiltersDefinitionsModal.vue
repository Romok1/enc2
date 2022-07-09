<template>
  <dashboard-modal
    v-model="show"
    class="modal--dashboard"
    @close="close"
  >
    <template slot="header">
      <h2 class="dashboard-modal__title">
        {{ t.title }}
      </h2>
    </template>

    <template slot="body">
      <p>
        <ul>
          <li 
            v-for="(definition, index) in definitions"
            :key="getUniqueVForKey('definition', index)"
            v-html="definition"
          />
        </ul>
      </p>
    </template>
  </dashboard-modal>
</template>

<script>
import DashboardModal from '~/components/dashboard/DashboardModal'
import mixinIds from '~/mixins/mixin-ids'

export default {
  components: { DashboardModal },

  mixins: [mixinIds],

  data () {
    return {
      show: false
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.shared.components.portfolio_options.filters_definitions')
    },

    biodiversityModule () {
      return this.$store.state.biodiversityGoals.dashboard.biodiversityModule
    },

    definitions () {
      return this.t.definitions.shared.concat(
        this.t.definitions[this.biodiversityModule]
      )
    }
  },

  created () {
    this.$root.$on('filter-definitions-modal:open', this.open)
  },

  methods: {
    close () {
      this.show = false
    },

    open () {
      this.show = true
    }
  }
}
</script>
