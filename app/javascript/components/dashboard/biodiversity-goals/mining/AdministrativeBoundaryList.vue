<template>
  <div class="administrative-boundary-list">
    <h2 class="administrative-boundary-list__title">
      {{ t.title }}
    </h2>

    <p class="administrative-boundary-list__intro">
      {{ t.intro }}
    </p>

    <v-table 
      :headers="tableHeaders"
      :rows="tableRows"
      :collapse-on-mobile="true"
      :row-limit="rowLimit"
    />
  </div>
</template>

<script>
import mixinDashboardTable from '~/mixins/mixin-dashboard-table'
import VTable from '~/components/v-table/VTable'

export default {
  components: { VTable },

  mixins: [mixinDashboardTable],
  
  props: {
    data: {
      type: Array,
      required: true
    },

    rowLimit: {
      type: Number,
      default: 0
    }
  },


  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.mining.components.global_overview.administrative_boundaries')    
    },

    tableHeaders () {
      const headers = this.t.table.headers

      return Object.keys(headers).map(headerId => ({
        id: headerId,
        label: headers[headerId],
        tooltip: this.getHeaderTooltip(headerId),
        textAlign: this.getTextAlignForHeader(headerId)
      }))
    },

    tableRows () {
      return this.data.map(boundary => ({
        administrativeBoundary: boundary.name,
        country: boundary.country,
        star: boundary.star
      }))
    }
  }
}
</script>