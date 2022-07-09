<template>
  <div class="ecoregion-list">
    <h2 class="ecoregion-list__title">
      {{ t.title }}
    </h2>

    <p class="ecoregion-list__intro">
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
      return this.$t('biodiversity_goals.dashboard.mining.components.global_overview.ecoregions')    
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
      return this.data.map(ecoregion => ({
        ecoregion: this.getEcoregionCell(ecoregion.category, ecoregion.name),
        countries: ecoregion.countries.join(', '),
        ecoIntegrityRisk: ecoregion.ecoIntegrityRisk
      }))
    }
  },

  methods: {
    getEcoregionCell (categoryId, ecoregionName) {
      return `<div class="ecoregion-list__cell--ecoregion">
        <span class="color-key--${categoryId}"></span>
        ${ecoregionName}
      </div>`
    }
  }
}
</script>