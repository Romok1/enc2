<template>
  <pane 
    :title="t.title"
    :tooltip="t.tooltip"
  >
    <div class="exposure-results">
      <div class="exposure-results__columns pdf-break-inside-avoid">
        <div
          v-for="(tile, index) in tiles" 
          :key="`exposure-results-tile-${index}`"
          class="exposure-results__column"
        >
          <div class="exposure-results__tile">
            <div class="exposure-results__text-container">
              <exposure-results-tile-text 
                :tile="tile" 
                :show-ecoregion-trigger="!isStarTile(tile)"
              />
            </div>

            <div class="exposure-results__chart-container">
              <ChartDial
                v-if="isStarTile(tile)"
                :text="tile.chartText"
                :data="getDialData(tile)"
                :legend="tile.legend"
              />

              <am-chart-donut
                v-else
                :text="tile.chartText"
                :data="tile.data && tile.data.ecoregionCategories"
                :animated="!forPdf"
                :legend-id="tile.legendId"
              />
            </div>

            <div
              v-if="!isStarTile(tile)" 
              class="exposure-results__legend"
            >
              <h3 class="exposure-results__legend-title">
                {{ t.legend_title }}
              </h3>

              <div 
                :id="tile.legendId"
                class="exposure-results__legend-items"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <ecoregion-management class="pdf-break-inside-avoid" />
    <ecoregion-categories 
      v-if="forPdf" 
      class="pdf-break-inside-avoid"
    />
    <ecoregion-categories-modal v-else />
  </pane>
</template>

<script>
import AmChartDonut from '~/components/chart/AmChartDonut'
import ChartDial from '~/components/chart/ChartDial'
import EcoregionManagement from '~/components/dashboard/biodiversity-goals/common/EcoregionManagement'
import EcoregionCategories from '~/components/dashboard/biodiversity-goals/common/EcoregionCategories'
import EcoregionCategoriesModal from '~/components/dashboard/biodiversity-goals/common/EcoregionCategoriesModal'
import ExposureResultsTileText from '~/components/dashboard/biodiversity-goals/common/ExposureResultsTileText'
import Pane from '~/components/dashboard/Pane'

import mixinIds from '~/mixins/mixin-ids'

import { ecoregionColors } from '~/helpers/color-helpers'

const TILE_IDS = ['star', 'ecoIntegrityRisk']
const EXPOSURE_RESULTS_TEXT_PATH = 'biodiversity_goals.dashboard.shared.components.exposure_results'

export default {
  components: { 
    AmChartDonut,
    ChartDial,
    EcoregionCategories,
    EcoregionCategoriesModal,
    EcoregionManagement,
    ExposureResultsTileText,
    Pane
  },

  mixins: [mixinIds],

  props: {
    data: {
      type: Object,
      required: true
    },

    bioModule: {
      type: String,
      required: true,
      validator: str => ['agriculture', 'mining'].indexOf(str) !== -1
    },

    forPdf: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    t () {
      return this.$t(EXPOSURE_RESULTS_TEXT_PATH)
    },

    tiles () {
      const tiles = []

      TILE_IDS.forEach( id => {
        const tile = { ...this.t.tiles[id], id }

        tile.legendId = this.getUniqueVForKey('legend', tile.id)
        tile.data = this.data[id]
        tile.chartText = this.getChartText(tile)

        if (!this.isStarTile(tile) && tile.data) {
          tile.data.ecoregionCategories.forEach(this.addCategoryLabelAndColor)
        }

        tiles.push(tile)
      })

      return tiles
    }
  },
  
  methods: {
    getDialData (tile) {
      if (!tile.data) { return null }

      const averageOptions = ['below', 'average', 'above']

      return {
        value: averageOptions.indexOf(tile.data.comparisonToAverage) + 1,
        max: 3
      }
    },

    addCategoryLabelAndColor(category) {
      const ecoregionCategory = category.category.toLowerCase()

      category.label = this.$t('biodiversity_goals.dashboard.shared.ecoregion_categories')[ecoregionCategory]
      category.color = ecoregionColors[ecoregionCategory]
    },

    getChartText (tile) {
      if (!tile.data) { return {} }

      const center = this.getChartCenterText(tile)
      const caption = this.isStarTile(tile) ? this.getDonutCaption(tile) : null

      return { center, caption }
    },

    getChartCenterText (tile) {
      return this.$t(`${this.getChartTextPath(tile)}.total`,
        { value: tile.data.allThreats }
      )
    },

    isStarTile (tile) {
      return tile.id === 'star'
    },

    getDonutCaption (tile) {
      const chartTextPath = this.getChartTextPath(tile)
      
      return [
        this.$t(`${chartTextPath}.${this.bioModule}`,
          { value: tile.data.sectorThreats }
        ),
        this.$t(`${chartTextPath}.other`,
          { value: tile.data.otherThreats }
        )
      ]
    },

    getChartTextPath (tile) {
      return `${EXPOSURE_RESULTS_TEXT_PATH}.tiles.${tile.id}.threats`
    }
  }
}
</script>
