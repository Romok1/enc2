<template>
  <div class="dashboard dashboard--biodiversity-goals">
    <div class="dashboard__body">
      <div
        class="dashboard__panel"
      >
        <template>
          <div class="dashboard-panel">
            <div class="dashboard-panel__header">
              <div class="dashboard-panel__header-text">
                <span
                  v-if="$slots.icon"
                  class="dashboard-panel__icon"
                >
                  <slot name="icon" />
                </span>
                
                <h1 class="dashboard-panel__title">
                  <span :class="{ 'pdf-hide': !portfolioName }">
                    {{ portfolioTitle }}
                  </span>
                </h1>

                <div
                  v-if="isDirty"
                  class="dashboard-panel__warning-text pdf-hide"
                >
                  {{ $t('portfolios.notifications.unsaved_changes') }}
                </div>
                <DashboardDetails class="pdf-hide" />
              </div>

              <div class="dashboard-panel__tools">
                <ul class="dashboard-panel__tools-items">
                  <li class="dashboard-panel__tools-item">
                    <EditButton class="dashboard-button" />
                  </li>
                  <li class="dashboard-panel__tools-item">
                    <SaveButton class="dashboard-button" />
                  </li>
                  <li class="dashboard-panel__tools-item">
                    <DownloadButton class="dashboard-button" />
                  </li>
                </ul>
              </div>
            </div>

            <loading-spinner v-if="busy" />

            <div
              v-else-if="hasData"
              class="dashboard-panel__body"
            >
              <slot name="body" />
            </div>

            <message
              v-else
              class="dashboard-message--no-dashboard-data"
              :text="$t('biodiversity_goals.dashboard.data.no_data')"
            >
              <template v-slot:icon>
                <icon-business-plan />
              </template>
            </message>
          </div>
        </template>
      </div>
    </div>

    <slot name="appends" />
  </div>
</template>

<script>
import DashboardDetails from '~/components/dashboard/Details'
import DownloadButton from '~/components/dashboard/buttons/Download'
import EditButton from '~/components/dashboard/buttons/Edit'
import IconBusinessPlan from '~/icons/IconBusinessPlan'
import LoadingSpinner from '~/common/LoadingSpinner'
import Message from '~/components/dashboard/Message'
import SaveButton from '~/components/dashboard/buttons/Save'

export default {
  components: {
    DashboardDetails,
    DownloadButton,
    EditButton,
    IconBusinessPlan,
    LoadingSpinner,
    Message,
    SaveButton
  },

  props: {
    busy: {
      type: Boolean,
      required: true
    },
    hasData: {
      type: Boolean,
      required: true
    },
    isDirty: {
      type: Boolean,
      required: true
    }
  },

  computed: {
    portfolio () {
      return this.$store.state.portfolio
    },

    portfolioTitle () {
      return this.portfolioName || this.$t('biodiversity_goals.dashboard.portfolio.ctas.save_to_portfolio')
    },

    portfolioName () {
      return this.portfolio ? this.portfolio.name :
        undefined
    }
  }
}
</script>
