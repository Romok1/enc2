<template>
  <Pane
    :title="t.title"
  >
    <div class="agri-global-overview">
      <div class="agri-global-overview__header">
        <p class="agri-global-overview__text">
          {{ t.description }}
        </p>
      </div>

      <div
        v-for="regionType in regionTypes" 
        :key="getUniqueVForKey('section', regionType)"
        class="agri-global-overview__section"
      >
        <h3 class="agri-global-overview__heading">
          {{ t[regionType].title }}
        </h3>

        <p 
          class="agri-global-overview__text"
          v-html="t[regionType].description"
        />

        <VTable
          class="agri-global-overview__table"
          :headers="getTableHeaders(regionType)"
          :rows="tablesByRegionType[regionType]"
          :no-rows-message="t.table.no_data[regionType]"
          :collapse-on-mobile="true"
        />
      </div>
    </div>
  </Pane>
</template>

<script>
import Pane from '~/components/dashboard/Pane'
import VTable from '~/components/v-table/VTable'
import mixinDashboardTable from '~/mixins/mixin-dashboard-table'
import mixinIds from '~/mixins/mixin-ids'

const TABLE_HEADERS_BY_REGION_TYPE = {
  administrativeBoundaries: ['country', 'agricultureType', 'administrativeBoundary', 'star'],
  ecoregions: ['country', 'agricultureType', 'ecoregion', 'ecoIntegrityRisk']
}

export default {
  components: {
    Pane,
    VTable
  },

  mixins: [mixinDashboardTable, mixinIds],

  props: {
    data: {
      type: Object,
      required: true
    },

    animated: {
      type: Boolean,
      default: true
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.agriculture.components.global_overview')
    },

    regionTypes () {
      return Object.keys(TABLE_HEADERS_BY_REGION_TYPE)
    },

    tablesByRegionType () {
      return {
        ecoregions: this.tableEcoregions,
        administrativeBoundaries: this.tableAdministrativeBoundaries
      }
    },

    tableEcoregions () {
      return this.data.ecoregions.regionsAgricultureTypeJoin.map(rowData => ({
        ...this.getTableRowSharedColumns(rowData),
        ecoregion: {
          filterValue: rowData.ecoregion.filterValue,
          content: this.getEcoregionCell(rowData.ecoregion),
        },
        ecoIntegrityRisk: rowData.ecoIntegrityRisk
      }))
    },

    tableAdministrativeBoundaries () {
      return this.data.administrativeBoundaries.regionsAgricultureTypeJoin.map(rowData => ({
        ...this.getTableRowSharedColumns(rowData),
        administrativeBoundary: {
          filterValue: rowData.administrativeBoundary.filterValue,
          content: rowData.administrativeBoundary.name,
        },
        star: rowData.star,
      }))
    }
  },

  methods: {
    getEcoregionCell (ecoregion) {
      return `<div class="flex">
        <span class="color-key--${ecoregion.category}"></span>
        ${ecoregion.name}
      </div>`
    },

    getTableHeaders (regionType) {
      return TABLE_HEADERS_BY_REGION_TYPE[regionType].map(
        headerId => this.getTableHeader(regionType, headerId)
      )
    },

    getTableHeader (regionType, headerId) {
      const header = {
        id: headerId,
        label: this.t.table.headers[headerId],
        tooltip: this.getHeaderTooltip(headerId),
        textAlign: this.getTextAlignForHeader(headerId)
      }

      if (this.data[regionType].filters[headerId]) {
        const options = this.data[regionType].filters[headerId]

        header.filter = {
          id: headerId,
          selectedLabel: this.t.table.filters.selectedLabel[headerId],
          selected: options[0].id,
          options: options
        }
      }

      return header
    },

    getTableRowSharedColumns (rowData) {
      return {
        country: rowData.country,
        agricultureType: {
          filterValue: rowData.agricultureType.filterValue,
          content: rowData.agricultureType.name
        }
      }
    }
  }
}
</script>
