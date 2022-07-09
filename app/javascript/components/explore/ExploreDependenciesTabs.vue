<template>
  <tabs
    modifier="explore-inner"
    @tab-changed="selectTab($event)"
  >
    <tab
      :id="servicesId"
      :title="common_t.e_services"
      :tooltip="tooltips_t['services']"
      :active="true"
    >
      <explore-content-service-list 
        :get-map-path="getMapPath" 
        :get-factsheet-path="getFactsheetPath" 
      />
    </tab>

    <tab
      :id="assetsId"
      :title="common_t.assets_short"
      :tooltip="tooltips_t['assets']"
    >
      <explore-content-assets 
        nested-model="es"
        :parent-tab-id="assetsId"
        :categories="ecoServiceCategories" 
      />
    </tab>
  </tabs>
</template>

<script>
import { getMapURLByServiceId, getEcosystemServicePath } from '~/helpers/request-helpers'
import { DEPENDENCIES_ASSETS_ID, DEPENDENCIES_SERVICES_ID } from '~/helpers/explore-helpers'
import ExploreContentAssets from './ExploreContentAssets'
import ExploreContentServiceList from './ExploreContentServiceList'
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'

export default {
  components: {
    ExploreContentAssets,
    ExploreContentServiceList,
    Tab,
    Tabs
  },

  data () {
    return {
      getMapPath: getMapURLByServiceId,
      getFactsheetPath: getEcosystemServicePath,
      assetsId: DEPENDENCIES_ASSETS_ID,
      servicesId: DEPENDENCIES_SERVICES_ID
    }
  },

  computed: {
    ecoServiceCategories () {
      return this.$store.state.explore.categories
    },

    common_t () {
      return this.$t('common')
    },

    tooltips_t () {
      return this.$t('tooltips')
    },
  },

  methods: {
    selectTab (id) {
      this.$emit('select-tab', id)
    }
  }

}
</script>