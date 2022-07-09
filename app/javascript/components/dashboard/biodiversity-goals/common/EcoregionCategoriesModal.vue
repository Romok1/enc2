<template>
  <dashboard-modal
    v-model="show"
    class="modal--dashboard modal--large"
    @close="close"
  >
    <template slot="header">
      <h2 class="dashboard-modal__title">
        {{ t.title }}
      </h2>
    </template>

    <template slot="body">
      <ecoregion-categories class="ecoregion-categories--modal" />
    </template>
  </dashboard-modal>
</template>

<script>
import DashboardModal from '~/components/dashboard/DashboardModal'
import EcoregionCategories from '~/components/dashboard/biodiversity-goals/common/EcoregionCategories'

export default {
  components: { EcoregionCategories, DashboardModal },

  data () {
    return {
      show: false
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.shared.components.exposure_results.ecoregion_categories_modal')
    }
  },

  created () {
    this.$root.$on('ecoregion-categories-modal:open', this.open)
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
