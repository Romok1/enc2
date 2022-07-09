<template>
  <div>
    <tabs-fake 
      :children="tabs"
      class="dashboard__tabs tabs-fake--rounded"
      @click:tab="changeTab"
    />

    <loading-spinner v-if="$store.state.naturalCapital.dashboard.busy || busy" />
    <div v-else>
      <am-chart-sankey
        v-show="chartHasData"
        class="dashboard__chart"
        :data="chartData"
      />

      <message 
        v-show="!chartHasData"
        class="dashboard-message--no-flows-data"
        :text="t.no_data"
      >
        <template v-slot:icon>
          <icon-sankey />
        </template>
      </message>

      <message 
        class="dashboard-message--screensize"
        :text="t.screensize"
      >
        <template v-slot:icon>
          <icon-devices />
        </template>
      </message>
    </div>
  </div>
</template>

<script>
import AmChartSankey from '~/components/chart/AmChartSankey'
import IconDevices from '~/icons/IconDevices'
import IconSankey from '~/icons/IconSankey'
import LoadingSpinner from '~/common/LoadingSpinner'
import Message from '~/components/dashboard/Message'
import TabsFake from '~/components/tabs/TabsFake'

export default {
  name: 'Flows',

  components: { 
    AmChartSankey,
    IconDevices,
    IconSankey,
    LoadingSpinner,
    Message,
    TabsFake 
  },

  props: {
    tabs: {
      required: true,
      type: Array //[{ id: String, title: String }]
    }
  },

  data () {
    return {
      busy: false,
      chartData: [],
      selectedTabId: this.tabs[0].id
    }
  },

  computed: {
    chartHasData () {
      return this.chartData.length > 0
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
      return this.$t('natural_capital.dashboard.flows')
    }
  },

  watch: {
    selections () {
      this.updateData()
    },
  },

  mounted ()  {
    this.updateData()
  },

  methods: {
    updateData () {
      if (this.selectedSubIndustryIds.length) {
        this.fetchDashboardFlowsData()
      } else {
        this.chartData = []
      }
    },

    fetchDashboardFlowsData () {
      const data = {
        params: {
          production_process_ids: this.selectedProductionProcessIds,
          sub_industry_ids: this.selectedSubIndustryIds,
          type: this.selectedTabId
        }
      }
      
      this.busy = true

      this.$http.get(`/${this.$i18n.locale}/tools/natural-capital-dashboard/flows`, data)
        .then(response => {
          this.updateSankeyChart(response.data)
        })
        .catch(function (error) {
          console.error(error)
        })
        .finally(() => (this.busy = false))
    },

    changeTab (selected) {
      this.selectedTabId = selected
      this.updateData()
    },

    updateSankeyChart (data) {
      this.chartData = data
    }
  }
}
</script>
