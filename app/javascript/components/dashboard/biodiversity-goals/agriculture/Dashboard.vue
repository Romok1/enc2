<template>
  <dashboard
    class="dashboard--agriculture"
    v-bind="{
      busy,
      hasData: Boolean(data),
      isDirty
    }"
  >
    <template v-slot:icon>
      <icon-agriculture />
    </template>

    <template v-slot:body>
      <agriculture-details 
        v-if="forPdf"
        :in-modal="false"
      />

      <exposure-results
        :data="data.exposureResults"
        bio-module="agriculture"
        :for-pdf="forPdf"
      />

      <agri-global-overview
        class="pdf-break-inside-avoid"
        :data="data.globalOverview"
      />

      <portfolio-options
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
          <agriculture-details />
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
              selected-sector="agriculture"
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
          type: 'agriculture'
        }"
      />
    </template>
  </dashboard>
</template>
<script>
import mixinDashboard from '~/components/dashboard/biodiversity-goals/portfolio-generators/mixins/mixin-dashboard'
import AgricultureDetails from '../../details/Agriculture'
import Generator from '~/components/dashboard/biodiversity-goals/portfolio-generators/Generator'
import DashboardModal from '~/components/dashboard/DashboardModal'
import Dashboard from '~/components/dashboard/biodiversity-goals/Dashboard'
import ExposureResults from '~/components/dashboard/biodiversity-goals/common/ExposureResults'
import IconAgriculture from '~/icons/IconAgriculture'
import ModalFull from '~/components/modal/ModalFull'
import PortfolioOptions from '~/components/dashboard/biodiversity-goals/common/PortfolioOptions'
import AgriGlobalOverview from './AgriGlobalOverview'
import SaveModal from '~/components/dashboard/SaveModal'

export default {
  components: {
    AgricultureDetails,
    Generator,
    Dashboard,
    DashboardModal,
    ExposureResults,
    ModalFull,
    IconAgriculture,
    PortfolioOptions,
    AgriGlobalOverview,
    SaveModal
  },

  mixins: [mixinDashboard],

  created () {
    this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateSelectedSector', 'agriculture')
    this.$store.dispatch('biodiversityGoals/dashboard/updateBiodiversityModule', 'agriculture')
  }
}
</script>
