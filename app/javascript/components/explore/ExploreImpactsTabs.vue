<template>
  <tabs
    modifier="explore-inner"
    @tab-changed="selectTab($event)"
  >
    <tab
      :id="impactDriversId"
      :title="common_t.impact_drivers"
      :active="true"
    >
      <explore-content-impact-drivers-list
        :items="impactDrivers" 
        :is-category-active="true"
        :get-factsheet-path="getFactsheetPath"
      />
    </tab>

    <tab
      :id="assetsId"
      :title="common_t.assets_short"
    >
      <explore-content-assets 
        :parent-tab-id="assetsId" 
        nested-model="id" 
      />
    </tab>
  </tabs>
</template>

<script>
import ExploreContentAssets from './ExploreContentAssets'
import ExploreContentImpactDriversList from './ExploreContentImpactDriversList'
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'
import { getImpactDriverPath } from '~/helpers/request-helpers'
import { IMPACTS_IMPACT_DRIVERS_ID, IMPACTS_ASSETS_ID } from '~/helpers/explore-helpers'

export default {
  components: {
    ExploreContentAssets,
    ExploreContentImpactDriversList,
    Tab,
    Tabs
  },
  
  data () {
    return {
      getFactsheetPath: getImpactDriverPath,
      impactDriversId: IMPACTS_IMPACT_DRIVERS_ID,
      assetsId: IMPACTS_ASSETS_ID
    }
  },

  computed: {
    impactDrivers () {
      return this.$store.state.explore.impactDrivers
    },

    common_t () {
      return this.$t('common')
    },

    tooltips_t () {
      return this.$t('tooltips')
    },
  },

  created () {
    this.$store.commit('explore/initializeImpactDrivers', { vm: this })
  },

  methods: {
    selectTab (id) {
      this.$emit('select-tab', id)
    }
  }

}
</script>