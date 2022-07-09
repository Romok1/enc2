<template>
  <div class="exposure-results-tile-text">
    <h3 class="exposure-results-tile-text__sub-header">
      {{ tile.title }}

      <dashboard-tooltip :tooltip="tile.tooltip" />
    </h3>

    <p class="exposure-results-tile-text__intro">
      {{ tile.description }}
    </p>

    <p 
      v-if="tile.data"
      class="exposure-results-tile-text__intro"
      v-html="getPortfolioScoreHtml(tile)"
    />
    
    <template v-if="tile.title_2 && tile.description_2">
      <h3 class="exposure-results-tile-text__sub-header--small">
        {{ tile.title_2 }}
      </h3>

      <p class="exposure-results-tile-text__intro">
        {{ tile.description_2[biodiversityModule] }}
      </p>
    </template>

    <div 
      v-if="showEcoregionTrigger"
      class="exposure-results-tile-text__trigger-wrapper pdf-hide"
    >
      <h4 class="exposure-results-tile-text__trigger-header">
        {{ t.breakdown_title }}
      </h4>

      <button
        class="exposure-results-tile-text__trigger" 
        @click="openEcoregionCategoriesModal"
      >
        {{ t.breakdown_link }}
      </button>
    </div>
  </div>
</template>

<script>
import DashboardTooltip from '~/components/dashboard/DashboardTooltip'

const EXPOSURE_RESULTS_TEXT_PATH = 'biodiversity_goals.dashboard.shared.components.exposure_results'

export default {
  components: { DashboardTooltip },

  props: {
    tile: {
      type: Object,
      required: true
    },

    showEcoregionTrigger: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    t () {
      return this.$t(EXPOSURE_RESULTS_TEXT_PATH)
    },

    biodiversityModule () {
      return this.$store.state.biodiversityGoals.dashboard.biodiversityModule
    }
  },

  methods: {
    getPortfolioScoreHtml () {
      const averageText = this.$t(
        `${EXPOSURE_RESULTS_TEXT_PATH}.portfolio_score.average.${this.tile.data.comparisonToAverage}`
      ).toLowerCase()

      return this.$t(`${EXPOSURE_RESULTS_TEXT_PATH}.tiles.${this.tile.id}.portfolio_score_html.${this.biodiversityModule}`,
        { 
          average: averageText,
          value: this.tile.data.sectorPercentage || null
        }
      )
    },

    openEcoregionCategoriesModal () {
      this.$root.$emit('ecoregion-categories-modal:open')
    }
  }
}
</script>