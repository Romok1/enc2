<template>
  <pane
    :title="t.title"
    :open="true"
  >
    <div class="portfolio-options">
      <div class="portfolio-options__header">
        <p class="portfolio-options__intro">
          {{ t.intro }}
        </p>

        <p class="portfolio-options__intro">
          <button
            class="portfolio-options__trigger" 
            @click="openFilterDescriptionsModal"
          >
            {{ t.filters_definitions.link }}
          </button>
        </p>


        <filters-bar
          class="portfolio-options__filters filters-bar--portolio-options pdf-hide"
          @reset:filters="clearFilters"
        >
          <template slot="filters">
            <div class="dashboard-filters--portfolio-options">
              <ul class="dashboard-filters__items">
                <li
                  v-for="(filter, index) in alignmentOptionFilters"
                  :key="getUniqueVForKey('filters-item', index)"
                  class="dashboard-filters__item"
                >
                  <v-multiselect-searchable
                    class="dashboard-filters__dropdown v-select--fullscreen-tablet"
                    :config="{
                      id: filter.config.id,
                      toggleLabel: filter.config.name
                    }"
                    :disabled="busy"
                    :options="filter.options"
                    :selected="getSelectedOptionId(filter.config.id)"
                    @update:selected-option="onSelectedFilterOptions(filter.config.id, $event)"
                  />
                </li>
              </ul>
            </div>
          </template>
        </filters-bar>

        <ul class="portfolio-options__selections pdf-only">
          <li 
            v-for="(value, key) in selectedOptionIds"
            :key="getUniqueVForKey('selected-option', key)"
            class="portfolio-options__selection"
            v-html="getSelectedOptionsRow(key, value)"
          />
        </ul>
      </div>
      <div class="portfolio-options__body">
        <loading-spinner v-if="busy" />
        <div
          v-else
          id="pdf-alignment-options"
          class="portfolio-options__tiles"
        >
          <ul
            v-if="portfolioOptions.length"
            class="portfolio-options__items"
            :class="{ 'portfolio-options__items--collapsed': isCollapsed }"
          >
            <li
              v-for="(option, index) in portfolioOptions"
              :key="`portolio-tile-${index}`"
              class="portfolio-options__item pdf-break-inside-avoid"
            >
              <div class="portfolio-option__tile">
                <span
                  v-if="option.priority === 1"
                  class="portfolio-option__ribbon"
                >
                  {{ t.ribbon_text }}
                </span>
                <h4 class="portfolio-option__title">
                  {{ option.principle }}
                </h4>
                <p
                  v-if="option.description"
                  class="portfolio-option__text"
                >
                  {{ option.description }}
                </p>
                <a
                  v-if="option.resource"
                  :href="option.resource"
                  target="_blank"
                  class="portfolio-option__link"
                >
                  {{ t.options.link_text }}
                </a>
              </div>
            </li>
          </ul>
          <div
            v-else
            class="portfolio-option__no-results"
          >
            {{ t.no_results }}
          </div>
        </div>
      </div>
      <div
        v-if="portfolioOptions.length > 4"
        class="portfolio-options__footer pdf-hide"
      >
        <button
          class="portfolio-options__button"
          @click="onClick"
        >
          {{ toggleText }}
        </button>
      </div>
    </div>

    <FiltersDefinitionsModal />
  </pane>
</template>

<script>
import FiltersBar from '~/components/filters-bar/FiltersBar'
import FiltersDefinitionsModal from '~/components/dashboard/biodiversity-goals/common/FiltersDefinitionsModal'
import Pane from '~/components/dashboard/Pane'
import LoadingSpinner from '~/common/LoadingSpinner'
import VMultiselectSearchable from '~/components/v-select/VMultiselectSearchable'
import mixinIds from '~/mixins/mixin-ids'
import { getAlignmentOptionsQueryString } from '~/helpers/request-helpers'

export default {
  components: {
    FiltersBar,
    FiltersDefinitionsModal,
    LoadingSpinner,
    Pane,
    VMultiselectSearchable
  },

  mixins: [mixinIds],

  props: {
    module: {
      type: String,
      required: true
    },
    initialPortfolioOptions: {
      type: Array,
      default: () => undefined
    },
    lockPortfolioOptions: {
      type: Boolean,
      default: false
    },
    alignmentOptionFilterSelections: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      alignmentOptionFilters: [],
      busy: true,
      isCollapsed: true,
      portfolioOptions: []
    }
  },

  computed: {
    selectedOptionIds: {
      get () {
        return this.$store.state.biodiversityGoals.dashboard.alignmentOptionSelections
      },

      set (selections) {
        this.$store.dispatch('biodiversityGoals/dashboard/updateAlignmentOptionSelections', selections)
      }
    },

    queryString () {
      return getAlignmentOptionsQueryString({
        selectedOptionIds: this.selectedOptionIds, 
        moduleName: this.module
      })
    },

    t () {
      return this.$t('biodiversity_goals.dashboard.shared.components.portfolio_options')
    },

    toggleText () {
      return this.isCollapsed
        ? this.$t('buttons.show_more')
        : this.$t('buttons.show_less')
    }
  },

  watch: {
    selectedOptionIds: {
      deep: true,
      handler () {
        this.getPortolioOptions()
      }
    }
  },

  created () {
    this.initialiseDashboard()
  },

  methods: {
    initialiseDashboard () {
      if (this.initialPortfolioOptions) {
        this.portfolioOptions = this.initialPortfolioOptions
      }

      this.setDropdownFilters()
      this.getPortolioOptions()
    },

    onClick () {
      this.isCollapsed = !this.isCollapsed
    },

    onSelectedFilterOptions (filterId, selectedFilterOptionIds) {
      const noCurrentSelectedOptions =
        !this.selectedOptionIds[filterId] ||
        !this.selectedOptionIds[filterId].length

      if (!selectedFilterOptionIds.length && noCurrentSelectedOptions) {
        return
      }

      this.selectedOptionIds = { ...this.selectedOptionIds, [filterId]: selectedFilterOptionIds }
    },

    getSelectedOptionId (id) {
      return this.selectedOptionIds[id]
    },

    setDropdownFilters () {
      this.busy = true

      this.$http.get(`/${this.$i18n.locale}/alignment_options/dropdown_values?biodiversity_module=${this.module}`)
        .then(response => {
          this.alignmentOptionFilters = response.data
          this.selectedOptionIds = this.alignmentOptionFilterSelections || {}
        })
        .catch(error => { console.log('error', error) })
        .finally(() => {
          this.busy = false
        })
    },

    clearFilters () {
      this.selectedOptionIds = {}
    },

    getPortolioOptions () {
      if (this.lockPortfolioOptions) { return }

      const timeout = setTimeout(() => {
        this.busy = true
      }, 250)

      this.$http.get(`/${this.$i18n.locale}/alignment_options/fetch?${this.queryString}`)
        .then(response => {
          this.portfolioOptions = response.data
        })
        .catch(error => { console.log('error', error) })
        .finally(() => {
          clearTimeout(timeout)

          this.busy = false
        })

    },

    getSelectedOptionsRow (filterId, optionIds) {
      const filterName = this.$i18n.t(`biodiversity_goals.dashboard.shared.components.portfolio_options.filters.${filterId}`)
      const selectedOptions = this.getAlignmentOptionFilterOptions(filterId).filter(option => 
        optionIds.indexOf(option.id) > -1
      )

      return `<strong>${filterName}:</strong> ${selectedOptions.map(o => o.name).join(', ')}`
    },

    getAlignmentOptionFilterOptions (filterId) {
      return this.alignmentOptionFilters.filter(filter => filter.config.id === filterId)[0].options
    },

    openFilterDescriptionsModal () {
      this.$root.$emit('filter-definitions-modal:open')
    }
  }
}
</script>
