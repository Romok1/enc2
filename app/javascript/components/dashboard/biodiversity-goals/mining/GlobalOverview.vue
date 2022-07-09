<template>
  <pane
    :title="t.title"
    :tooltip="t.tooltip"
  >
    <global-overview-averages :data="data.averages" />  

    <administrative-boundary-list 
      v-if="data.administrativeBoundaries.length > 0" 
      :data="data.administrativeBoundaries"
      :row-limit="rowLimit" 
    />  

    <ecoregion-list 
      v-if="data.ecoregions.length > 0"
      :data="data.ecoregions"
      :row-limit="rowLimit"
    />
  </pane>
</template>

<script>
import EcoregionList from '~/components/dashboard/biodiversity-goals/mining/EcoregionList'
import AdministrativeBoundaryList from '~/components/dashboard/biodiversity-goals/mining/AdministrativeBoundaryList'
import GlobalOverviewAverages from '~/components/dashboard/biodiversity-goals/mining/GlobalOverviewAverages'
import Pane from '~/components/dashboard/Pane'

const ROW_LIMIT = 3

export default {
  components: {
    AdministrativeBoundaryList,
    GlobalOverviewAverages,
    EcoregionList,
    Pane
  },

  props: {
    data: {
      type: Object,
      required: true
    },

    forPdf: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.mining.components.global_overview')    
    },

    rowLimit () {
      return this.forPdf ? 0 : ROW_LIMIT
    }
  }
}
</script>
