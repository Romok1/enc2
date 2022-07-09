<template>
  <div class="dashboard dashboard--nat-cap">
    <div class="dashboard__header">
      <div class="dashboard__header-content">
        <h1 class="dashboard__title">
          {{ $t('natural_capital.dashboard.title') }}
        </h1>

        <div class="dashboard__fake-tabs">
          <tabs-fake
            class="tabs-fake--basic"
            :children="tabs"
            default-selected-id="dashboard"
            @click:tab="changeTab"
          />
        </div>
      </div>
      <filters />
    </div>

    <div class="dashboard__body">
      <div
        v-if="showTabContent('flows')"
        class="dashboard__panel"
      >
        <flows :tabs="flowsTabs" />
      </div>

      <div
        v-else-if="showTabContent('dashboard')"
        class="dashboard__panel"
      >
        <template>
          <loading-spinner v-if="$store.state.naturalCapital.dashboard.busy || busy" />

          <div
            v-else-if="data"
            class="dashboard-panel"
          >
            <div class="dashboard-panel__header">
              <div class="dashboard-panel__header-text">
                <h1 class="dashboard-panel__title">
                  <span class="dashboard-panel__icon">
                    <IconBusinessPlan />
                  </span>
                  {{ portfolio ? portfolio.name : $t('portfolios.cta_save') }}
                </h1>

                <div
                  v-show="isPortfolioDirty"
                  class="dashboard-panel__warning-text"
                >
                  {{ $t('portfolios.notifications.unsaved_changes') }}
                </div>
              </div>

              <div class="dashboard-panel__tools">
                <ul class="dashboard-panel__tools-items">
                  <li class="dashboard-panel__tools-item">
                    <save-button class="dashboard-button--tablet-up" />
                  </li>
                </ul>
              </div>
            </div>

            <div class="dashboard-panel__body">
              <dependencies-impacts :data="data.dependenciesAndImpactsComponent" />

              <ratings-list
                category="ecosystem_services"
                :data="data.ecosystemServicesComponent"
              />

              <ratings-list
                category="impact_drivers"
                :data="data.impactDriversComponent"
              />

              <main-assets :data="data.assetsComponent" />
            </div>

            <natural-capital-modal />
          </div>

          <message
            v-else
            class="dashboard-message--no-dashboard-data"
            :text="t.no_data"
          >
            <template v-slot:icon>
              <icon-business-plan />
            </template>
          </message>

          <save-modal
            v-bind="{
              type: 'natural_capital'
            }"
          />
        </template>
      </div>
    </div>
  </div>
</template>
<script>
import { isEqual } from 'lodash'
import DependenciesImpacts from './DependenciesImpacts'
import Filters from './Filters'
import Flows from './Flows'
import IconBusinessPlan from '~/icons/IconBusinessPlan'
import LoadingSpinner from '~/common/LoadingSpinner'
import MainAssets from './MainAssets'
import Message from '~/components/dashboard/Message'
import NaturalCapitalModal from './NaturalCapitalModal'
import RatingsList from './RatingsList'
import SaveButton from '~/components/dashboard/buttons/Save'
import SaveModal from '~/components/dashboard/SaveModal'
import TabsFake from '~/components/tabs/TabsFake'

export default {
  name: 'Dashboard',

  components: {
    DependenciesImpacts,
    Filters,
    Flows,
    IconBusinessPlan,
    LoadingSpinner,
    MainAssets,
    Message,
    NaturalCapitalModal,
    RatingsList,
    SaveButton,
    SaveModal,
    TabsFake
  },

  props: {
    preloadData: {
      type: Object,
      default: undefined
    },

    flowsTabs: {
      required: true,
      type: Array
    },

    tabs: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      busy: false,
      data: undefined,
      selectedRecord: undefined,
      selectedTab: 'dashboard'
    }
  },

  computed: {
    isPortfolioDirty () {
      return this.portfolioSelections && !isEqual(this.portfolioSelections, this.selections)
    },

    portfolio () {
      return this.$store.state.portfolio
    },

    portfolioSelections () {
      if (this.portfolio) {
        return this.portfolio.request_structure
      }

      return undefined
    },

    selections () {
      return this.$store.state.naturalCapital.dashboard.selections
    },

    selectedSubIndustryIds () {
      return this.selections.sub_industry_ids
    },

    selectedProductionProcessIds () {
      return this.selections.production_process_ids
    },

    t () {
      return this.$t('natural_capital.dashboard.data')
    }
  },

  watch: {
    selections () {
      this.updateData()
    },

    portfolio (portfolio) {
      this.$store.dispatch('naturalCapital/dashboard/updateSelections', portfolio.request_structure)
    }
  },

  created () {
    if (this.preloadData) {
      this.data = this.preloadData
    }
  },

  methods: {
    changeTab (selected) {
      this.selectedTab = selected
    },

    onSaveButtonClick () {
      this.$root.$emit('show-dashboard-save-modal', true)
    },

    showTabContent (id) {
      return this.selectedTab == id
    },

    updateData () {
      if (this.selectedSubIndustryIds.length) {
        this.fetchDashboardData().then(response => (this.data = response.data))
      } else {
        this.data = undefined
      }
    },

    fetchDashboardData () {
      const data = {
        params: {
          production_process_ids: this.selectedProductionProcessIds,
          sub_industry_ids: this.selectedSubIndustryIds
        }
      }

      this.busy = true

      return new Promise((resolve, reject) => {
        this.$http.get(`/${this.$i18n.locale}/tools/natural-capital-dashboard/data`, data)
          .then(resolve)
          .catch(error => {
            console.error(error)
            reject(error)
          })
          .finally(() => (this.busy = false))
      })
    },
  }
}
</script>
