<template>
  <div class="v-table">
    <ul 
      v-if="headers.length"
      class="v-table__headers"
    >
      <li
        v-for="(header, headerIndex) in headers"
        :key="getUniqueVForKey('header', headerIndex)"
        class="v-table__header"
        :class="{'v-table__header--filter': header.filter}"
      >
        <template v-if="header.filter">
          <span class="v-table__header-text">
            <div>{{ header.label }}</div>

            <div class="v-table__header-selected">
              {{ getSelectedFiltersText(header) }}
            </div>
          </span>

          <v-select-searchable
            class="v-table__header-dropdown-icon"
            :config="getFilterConfig(header)"
            :options="header.filter.options"
            :selected="header.filter.selected"
            @update:selected-option="updateSelected(header.filter.id, $event)"
          />
        </template>

        <div
          v-else 
          v-html="header.label"
        />

        <DashboardTooltip 
          v-if="header.tooltip" 
          :tooltip="header.tooltip" 
        />
      </li>
    </ul>
    
    <ul
      v-if="filteredRows.length" 
      class="v-table__rows"
    >
      <li
        v-for="(row, rowIndex) in visibleRows"
        :key="getUniqueVForKey('row', rowIndex)"
        class="v-table__row"
        :class="{ expanded: isRowExpanded(rowIndex) }"
      >
        <ul class="v-table__cells">
          <template v-for="header in headers">
            <li
              v-if="showCell(rowIndex, header)"
              :key="getUniqueVForKey('header', header.id)"
              class="v-table__cell"
            >
              <h4
                class="v-table__cell-header"
                v-html="header.label"
              />

              <div 
                class="v-table__cell-content"
                :style="getCellStyle(header)"
                v-html="getCell(header, rowIndex)"
              />
            </li>
          </template>
        </ul>

        <button
          v-if="collapseOnMobile"
          class="v-table__row-toggle"
          @click="toggleExpanded(rowIndex)"
        >
          {{ getToggleText(rowIndex) }}
        </button>
      </li>
    </ul>

    <div 
      v-if="showShowAllRowsToggle"
      class="v-table__footer pdf-hide"
    >
      <button
        class="v-table__rows-toggle"
        @click="toggleShowAllRows"
      >
        {{ toggleShowAllRowsText }}
      </button>
    </div>

    <div 
      v-if="!filteredRows.length"
      class="v-table__no-rows"
    >
      {{ noRowsMessage }}
    </div>
  </div>
</template>

<script>
import mixinIds from '~/mixins/mixin-ids'
import { mixinResponsive } from '~/mixins/mixin-responsive'
import DashboardTooltip from '~/components/dashboard/DashboardTooltip.vue'
import VSelectSearchable from '~/components/v-select/VSelectSearchable.vue'

export default {
  components: { DashboardTooltip, VSelectSearchable },


  mixins: [mixinIds, mixinResponsive],
  
  props: {
    headers: {
      type: Array,
      default: () => [] 
    },

    rows: { // { [headerId]: String - HTML }[]
      type: Array,
      default: () => []
    },

    collapseOnMobile: {
      type: Boolean,
      default: false
    },

    noRowsMessage: {
      type: String,
      default: ''
    },

    rowLimit: {
      type: Number,
      default: 3
    }
  },

  data () {
    return {
      rowExpandedStates: {},
      appliedFilters: {},
      showAllFilteredRows: false
    }
  },

  computed: {
    filteredRows () {
      return this.rows.filter(this.isRowShown)
    },

    visibleRows () {
      if (this.rowLimit > 0 && !this.showAllFilteredRows) {
        return this.filteredRows.slice(0, this.rowLimit)
      }

      return this.filteredRows
    },

    showShowAllRowsToggle () {
      return this.rowLimit > 0 && 
        this.filteredRows.length > this.rowLimit
    },

    toggleShowAllRowsText () {
      return this.showAllFilteredRows ? this.$t('buttons.show_less') : 
        this.$t('buttons.show_more')
    }
  },

  created() {
    this.initAppliedFilters()
  },

  methods: {
    initAppliedFilters () {
      this.headers.forEach(header => {
        const filter = header.filter

        if (filter) {
          this.updateSelected(filter.id, filter.selected)
        }
      })
    },

    updateSelected (filterId, selectedOption) {      
      this.$set(this.appliedFilters, filterId, selectedOption)
    },

    isRowShown (row) {
      let validRow = true

      Object.keys(this.appliedFilters).forEach(headerId => {
        const appliedFilter = this.appliedFilters[headerId]

        if (validRow && appliedFilter !== 'all') {
          validRow = row[headerId].filterValue === appliedFilter
        }
      })

      return validRow
    },

    toggleShowAllRows () {
      this.showAllFilteredRows = !this.showAllFilteredRows
    },

    toggleExpanded (rowIndex) {
      this.$set(this.rowExpandedStates, rowIndex, !this.rowExpandedStates[rowIndex])
    },

    isRowExpanded (rowIndex) {
      return !!this.rowExpandedStates[rowIndex]
    },

    showCell (rowIndex, header) {
      return !this.collapseOnMobile || 
        header.id === this.headers[0].id || 
        this.isRowExpanded(rowIndex) ||
        !this.isSmall()
    },

    getCellStyle (header) {
      return {
        'text-align': header.textAlign || 'left'
      }
    },

    getCell (header, rowIndex) {
      const cell = this.filteredRows[rowIndex][header.id]
      const cellIsNotObject = typeof cell === 'string' || typeof cell === 'number'

      return cellIsNotObject ? cell : cell.content
    },

    getToggleText (rowIndex) {
      return this.isRowExpanded(rowIndex) ? 
        this.$t('buttons.collapse') : this.$t('buttons.expand')
    },

    getSelectedFiltersText (header) {
      const appliedFilterId = this.appliedFilters[header.filter.id]
      const appliedFilterName = header.filter.options
        .filter(o => o.id === appliedFilterId)[0]
        .name

      return `${header.filter.selectedLabel}: ${appliedFilterName}`
    },

    getFilterConfig (header) {
      return { ...header.filter, iconOnly: true }
    }
  }
}
</script>