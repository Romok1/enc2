<template>
  <filters-bar
    class="filters-bar--dashboard"
    @reset:filters="clearFilters"
  >
    <template slot="filters">
      <div class="dashboard-filters--header">
        <ul class="dashboard-filters__items">
          <li class="dashboard-filters__item">
            <v-multiselect-searchable
              class="dashboard-filters__dropdown v-select--fullscreen-mobile"
              :config="subIndustriesConfig"
              :disabled="busy"
              :options="subIndustries"
              :selected="selectedSubIndustryIds"
              @update:selected-option="onSelectedSubIndustryIds"
            />
          </li>
          <li class="dashboard-filters__item">
            <v-multiselect-searchable
              class="dashboard-filters__dropdown v-select--fullscreen-mobile"
              :config="productionProcessesConfig"
              :disabled="busy"
              :options="productionProcesses"
              :selected="selectedProductionProcessIds"
              @update:selected-option="onSelectedProductionProcessIds"
            />
          </li>
        </ul>
      </div>
    </template>

    <template slot="button-right">
      <save-button class="dashboard-button--mobile" />
    </template>
  </filters-bar>
</template>

<script>
import { intersection } from 'lodash'
import FiltersBar from '~/components/filters-bar/FiltersBar'
import SaveButton from '~/components/dashboard/buttons/Save'
import VMultiselectSearchable from '~/components/v-select/VMultiselectSearchable'

export default {
  components: {
    FiltersBar,
    SaveButton,
    VMultiselectSearchable
  },

  data () {
    return {
      subIndustriesConfig: {
        id: 'sub_industry',
        toggleLabel: this.$t('common.sub_industry'),
        hasSearch: true
      },
      productionProcessesConfig: {
        id: 'production_process',
        toggleLabel: this.$t('common.production_processes'),
        hasSearch: true
      },
      subIndustries: [],
      productionProcesses: []
    }
  },

  computed: {
    busy: {
      get () {
        return this.$store.state.naturalCapital.dashboard.busy
      },
      set (busy) {
        this.$store.state.naturalCapital.dashboard.busy = busy
      }
    },

    selectedSubIndustryIds () {
      return this.$store.state.naturalCapital.dashboard.selections.sub_industry_ids
    },

    selectedProductionProcessIds () {
      return this.$store.state.naturalCapital.dashboard.selections.production_process_ids
    }
  },

  created () {
    // Overwrite state persisted by turbolinks
    this.$store.dispatch('naturalCapital/dashboard/reset')
    this.initialiseDashboard()
  },

  methods: {
    initialiseDashboard () {
      this.$http.get(`/${this.$i18n.locale}/sub_industries`)
        .then(response => {
          this.subIndustries = response.data
          this.updateSelectionsAndProductionProcessOptions(this.selectedSubIndustryIds)
          this.$root.$emit('load-portfolio')
        })
    },

    onSelectedProductionProcessIds (selectedProductionProcessIds) {
      this.updateSelections({ production_process_ids: selectedProductionProcessIds })
    },

    onSelectedSubIndustryIds (selectedSubIndustryIds) {
      this.updateSelectionsAndProductionProcessOptions(selectedSubIndustryIds)
    },

    updateSelectionsAndProductionProcessOptions (selectedSubIndustryIds) {
      if (this.busy) return
      this.busy = true
      this.$http({
        method: 'get',
        url: `/${this.$i18n.locale}/natural-capital-filter`,
        params: {
          sub_industry_ids: selectedSubIndustryIds
        }
      })
        .then(response => {
          this.productionProcesses = response.data

          this.updateSelections({
            production_process_ids: this.getIntersectionOfSelectedProductionProcesses(),
            sub_industry_ids: selectedSubIndustryIds
          })
        })
        .finally(() => (this.busy = false))
    },

    /**
     * We use this to maintain the existing selections for Production Processes
     * when their available options are updated
     */
    getIntersectionOfSelectedProductionProcesses () {
      return intersection(
        this.selectedProductionProcessIds,
        this.productionProcesses.map(productionProcess => productionProcess.id)
      )
    },

    clearFilters () {
      this.updateSelections({
        sub_industry_ids: [],
        production_process_ids: []
      })
    },

    updateSelections (updatedSelections) {
      this.$store.dispatch('naturalCapital/dashboard/updateSelections', updatedSelections)
    }
  }
}
</script>
