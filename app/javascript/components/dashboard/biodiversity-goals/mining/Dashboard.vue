<template>
  <dashboard
    class="dashboard--mining"
    v-bind="{
      busy,
      hasData: Boolean(data),
      isDirty
    }"
  >
    <template v-slot:icon>
      <icon-mining />
    </template>

    <template v-slot:body>
      <mining-details 
        v-if="forPdf"
        :in-modal="false"
      />

      <exposure-results
        v-if="data.exposureResults"
        :data="data.exposureResults"
        bio-module="mining"
        :for-pdf="forPdf"
      />

      <global-overview
        v-if="data.globalOverview"
        class="pdf-break-inside-avoid"
        :data="data.globalOverview"
        :for-pdf="forPdf"
      />

      <exposure-scenarios
        v-if="data.futureExposureScenarios"
        class="pdf-break-inside-avoid"
        :commodities="data.futureExposureScenarios"
        :expanded-commodities="forPdf"
        :animated-bar-chart="!forPdf"
      />

      <portfolio-options
        v-if="data.alignmentOptions"
        class="pdf-break-inside-avoid"
        :module="module"
        :initial-portfolio-options="data.alignmentOptions"
        :lock-portfolio-options="forPdf"
        :alignment-option-filter-selections="data.alignmentOptionFilterSelections"
      />
    </template>

    <template v-slot:appends>
      <dashboard-modal v-model="showDetails">
        <template slot="header">
          <h2 class="dashboard-modal__title">
            {{ $t('portfolios.details.title') }}
          </h2>
        </template>

        <template slot="body">
          <mining-details />
        </template>
      </dashboard-modal>

      <div
        class="
          portfolio-generator-modal
          portfolio-generator-modal--biodiversity-goals
          portfolio-generator-modal--sector-selected
        "
      >
        <ModalFull v-model="showGenerator">
          <template v-slot:body>
            <Generator
              v-model="forms"
              selected-sector="mining"
            />
          </template>
          <template v-slot:footer>
            <PortalTarget name="portfolio-generator-modal-footer" />
          </template>
        </ModalFull>
      </div>
      <save-modal
        v-bind="{
          loadedPortfolio,
          type: 'mining'
        }"
      />
    </template>
  </dashboard>
</template>

<script>
import mixinDashboard from '~/components/dashboard/biodiversity-goals/portfolio-generators/mixins/mixin-dashboard'

import Dashboard from '~/components/dashboard/biodiversity-goals/Dashboard'
import MiningDetails from '~/components/dashboard/details/Mining'
import DashboardModal from '~/components/dashboard/DashboardModal'
import ExposureResults from '~/components/dashboard/biodiversity-goals/common/ExposureResults'
import ExposureScenarios from './ExposureScenarios'
import GlobalOverview from './GlobalOverview'
import IconMining from '~/icons/IconMining.vue'
import Generator from '~/components/dashboard/biodiversity-goals/portfolio-generators/Generator'
import ModalFull from '~/components/modal/ModalFull'
import PortfolioOptions from '~/components/dashboard/biodiversity-goals/common/PortfolioOptions'
import SaveModal from '~/components/dashboard/SaveModal'

export default {
  components: {
    Dashboard,
    DashboardModal,
    ExposureResults,
    ExposureScenarios,
    GlobalOverview,
    IconMining,
    Generator,
    MiningDetails,
    ModalFull,
    PortfolioOptions,
    SaveModal
  },

  mixins: [mixinDashboard],

  created () {
    this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateSelectedSector', 'mining')
    this.$store.dispatch('biodiversityGoals/dashboard/updateBiodiversityModule', 'mining')
  }
}
</script>
