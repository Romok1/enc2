<template>
  <pane
    :title="t.title"
    :tooltip="t.tooltip"
  >
    <div class="exposure-scenarios">
      <div class="exposure-scenarios__section">
        <div class="exposure-scenarios__header">
          <h4 class="exposure-scenarios__heading">
            {{ t.section_one.heading }}
          </h4>
          <p class="exposure-scenarios__text">
            {{ t.section_one.text }}
          </p>
        </div>


        <v-table
          class="exposure-scenarios__table"
          :headers="tableHeaders"
          :rows="tableRows"
        />
      </div>

      <div class="exposure-scenarios__section">
        <div class="exposure-scenarios__header--section-two">
          <h4 class="exposure-scenarios__heading">
            {{ t.section_two.heading }}
          </h4>
          <p class="exposure-scenarios__text">
            {{ t.section_two.text }}
          </p>
        </div>

        <template v-if="expandedCommodities">
          <exposure-scenarios-commodity
            v-for="(commodity, index) in commodities"
            :key="getUniqueVForKey('exposure-scenario-commodity', index)"
            :minerals="mineralsForSelect" 
            :commodities="[commodity]" 
          />
        </template>

        <exposure-scenarios-commodity
          v-else
          :minerals="mineralsForSelect" 
          :commodities="commodities" 
        />
      </div>
    </div>
  </pane>
</template>

<script>
import ExposureScenariosCommodity from './ExposureScenariosCommodity'
import Pane from '~/components/dashboard/Pane'
import VTable from '~/components/v-table/VTable'
import mixinIds from '~/mixins/mixin-ids'

export default {
  components: {
    ExposureScenariosCommodity,
    Pane,
    VTable,
  },

  mixins: [mixinIds],

  props: {
    commodities: {
      type: Array,
      required: true
    },

    expandedCommodities: {
      type: Boolean,
      default: false
    },

    animatedBarChart: {
      type: Boolean,
      default: true
    }
  },

  computed: {
    mineralsForSelect () {
      return this.commodities.map((commodity, index) => ({
        id: index,
        name: commodity.mineral,
      }))
    },

    tableHeaders () {
      const headersT = this.t.section_one.table.headers

      return Object.keys(headersT).map(id => ({
        id,
        label: this.getHeaderHtml(id, headersT[id])
      }))
    },

    tableRows () {
      const row = { supporting: '', not_supporting: '', not_assessed: '' }

      this.commodities.forEach(commodity => {
        row[commodity.alignment] += `<li>${commodity.mineral}</li>`
      })

      Object.keys(row).forEach(headerId => {
        if (row[headerId]) {
          row[headerId] = `<ul class="ul--unstyled">${row[headerId]}</ul>`
        }
      })

      return [row]
    },

    t () {
      return this.$t('biodiversity_goals.dashboard.mining.components.exposure_scenarios')
    },
  },

  methods: {
    getHeaderHtml (id, label) {
      return `<div class="exposure-scenarios__mineral-table-header">
        <span class="color-key--${id}"></span>${label}
      </div>`
    }
  }
}
</script>
