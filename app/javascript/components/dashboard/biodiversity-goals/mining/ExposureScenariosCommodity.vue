<template>
  <div class="exposure-scenarios-commodity pdf-break-inside-avoid">
    <div class="exposure-scenarios-commodity__header">
      <div class="exposure-scenarios-commodity__columns">
        <div class="exposure-scenarios-commodity__column">
          <p class="exposure-scenarios-commodity__selected-mineral">
            {{ commodities[selectedOption].mineral }}
          </p>

          <button
            class="exposure-scenarios-commodity__modal-trigger pdf-hide"
            type="button"
            @click="openModal"
          >
            {{ t.section_one.details_link }}
          </button>
        </div>

        <div 
          v-if="commodities.length > 1"
          class="exposure-scenarios-commodity__column exposure-scenarios-commodity__column--select"
        >
          <v-select-searchable
            v-model="selectedOption"
            class="exposure-scenarios-commodity__select"
            :config="{
              id: 'minerals'
            }"
            :options="minerals"
          />
        </div>
      </div>
    </div>

    <div class="exposure-scenarios-commodity__section exposure-scenarios-commodity__section--grey">
      <div class="exposure-scenarios-commodity__columns">
        <div class="exposure-scenarios-commodity__column">
          <h4 class="exposure-scenarios-commodity__heading">
            {{ t.section_two.charts.star.title }}
          </h4>
          <chart-scale
            v-bind="commodities[selectedOption].star"
            class="
              exposure-scenarios-commodity__chart-scale
              chart-scale--star
            "
            :title="$t('common.scale_log')"
          />
        </div>

        <div class="exposure-scenarios-commodity__column">
          <h4 class="exposure-scenarios-commodity__heading">
            {{ t.section_two.charts.ecoIntegrityRisk.title }}
          </h4>
          <chart-scale
            v-bind="commodities[selectedOption].ecoIntegrityRisk"
            class="
              exposure-scenarios-commodity__chart-scale
              chart-scale--ecoIntegrityRisk
            "
            :title="$t('common.scale')"
          />
        </div>
      </div>
    </div>

    <commodity-modal />
  </div>
</template>

<script>
import ChartScale from '~/components/chart/ChartScale'
import CommodityModal from '~/components/dashboard/biodiversity-goals/mining/CommodityModal'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: { ChartScale, CommodityModal, VSelectSearchable },

  props: {
    minerals: {
      type: Array,
      default: () => []
    },

    commodities: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedOption: 0
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.mining.components.exposure_scenarios')
    },

    chartLegend () {
      return [
        {
          id: 'commodityRange',
          text: this.t.section_two.charts.chart_legend.commodity_range
        },
        {
          id: 'commodityAverage',
          text: this.t.section_two.charts.chart_legend.commodity_average
        }
      ]
    }
  },

  methods: {
    openModal () {
      this.$root.$emit('commodity-modal:open', this.commodities[this.selectedOption])
    }
  }
}
</script>