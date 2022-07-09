<template>
  <filters-bar 
    class="filters-bar--explore" 
    @reset:filters="clearFilters"
  >
    <template slot="filters">
      <div class="explore-filters flex">
        <div
          v-for="filter in filters"
          :key="filter.id"
          class="explore-filters__selection"
        >
          <v-select-searchable
            v-if="!filter.isMultiple"
            class="explore-filters__dropdown v-select--fullscreen-tablet"
            :config="filter"
            :options="optionsById[filter.id]"
            :selected="selections[filter.id]"
            @update:selected-option="updateSelectedOptions(filter, $event)"
          >
            <template slot="label-icon">
              <tooltip :text="tooltips_t[filter.id]" />
            </template>
          </v-select-searchable>

          <v-multiselect-searchable
            v-else
            class="explore-filters__dropdown v-select--fullscreen-tablet"
            :config="filter"
            :options="optionsById[filter.id]"
            :selected="selections[filter.id]"
            @update:selected-option="updateSelectedOptions(filter, $event)"
          >
            <template slot="label-icon">
              <tooltip :text="tooltips_t[filter.id]" />
            </template>
          </v-multiselect-searchable>
        </div>
      </div>
    </template>
  </filters-bar>
</template>


<script>
import FiltersBar from '~/components/filters-bar/FiltersBar'
import Tooltip from '~/components/tooltip/Tooltip'
import VMultiselectSearchable from '~/components/v-select/VMultiselectSearchable'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'
import { UNDEFINED_ID } from '~/helpers/explore-helpers'
import { mixinResponsive } from '~/mixins/mixin-responsive'

export default {
  components: {
    FiltersBar,
    Tooltip,
    VMultiselectSearchable,
    VSelectSearchable
  },

  mixins: [mixinResponsive],

  props: {
    hasCollapsibleFilters: {
      default: true,
      type: Boolean
    }
  },

  data () {
    return {
      buttons_t: this.$t('buttons'),
      tooltips_t: this.$t('tooltips'),
      optionsById: {},
      undefinedObject: {id: UNDEFINED_ID, name: this.$t('common.none')}
    }
  },

  computed: {
    selections() {
      return this.$store.state.explore.selections
    },

    sectors() {
      return this.$store.state.explore.sectors
    },

    subIndustries() {
      return this.$store.state.explore.subIndustries
    },

    filters() {
      const t = this.$t('common')

      return this.$store.state.explore.filters.map((filter, index) => ({
        label: (index + 1) + '. ' + t[filter.id],
        ...filter
      }))
    }
  },

  watch: {
    selections () {
      this.setOptions()
    },
    sectors () {
      this.setOptions()
    }
  },

  created() {
    this.$store.commit('explore/initializeSectors', { vm: this })
    this.setOptions()
  },

  methods: {
    setOptions () {
      this.filters.forEach(filter => {
        this.$set(this.optionsById, filter.id, this.getOptions(filter))
      })
    },

    getOptions (filter) {
      let options = []

      if (filter.id === 'sub_industry') {
        options = this.selections.sector === UNDEFINED_ID
          ? [...this.subIndustries]
          : this.getSubIndustriesForSelectedSector()
      } else if (filter.id === 'production_process') {
        options = this.selections.sub_industry === UNDEFINED_ID
          ? []
          : this.getProductionProcessesForSelectedSubIndustry()
      } else {
        options = [...this.sectors]
      }

      if(options.length && !filter.isMultiple) { options.unshift(this.undefinedObject) }

      return options
    },

    getSelectedOptionIdForFilter (filter) {
      const selectedOption = this.selections[filter.id]

      return selectedOption ? selectedOption.id : null
    },

    getProductionProcessesForSelectedSubIndustry () {
      const selectedSubIndustry =
        this.subIndustries.find(
          sub_industry => this.selections.sub_industry == sub_industry.id
        )

      return selectedSubIndustry ? selectedSubIndustry.production_processes : []
    },

    getSubIndustriesForSelectedSector () {
      const selectedSector =
        this.sectors.find(
          sector => this.selections.sector == sector.id
        )

      return selectedSector ? [...selectedSector.sub_industries] : []
    },

    updateSelectedOptions (filter, newSelection) {
      this.$store.commit('explore/updateSelections', {
        vm: this,
        id: filter.id,
        newSelection
      })
    },

    clearFilters () {
      this.$store.commit('explore/resetSelections')
    }
  }
}
</script>
