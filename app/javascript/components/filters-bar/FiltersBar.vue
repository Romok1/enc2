<template>
  <div 
    class="filters-bar"
    :class="{'active': areFiltersActiveMobile}" 
  >
    <button
      type="button"
      class="filters-bar__filters-trigger"
      @click="openFilters"
    >
      <icon-filters class="filters-bar__filters-icon" />
    </button>

    <div class="filters-bar__filters-container">
      <div class="filters-bar__filters-content">
        <div class="filters-bar__filters-header">
          <div class="filters-bar__filters-title"> 
            {{ $t('common.filters') }}
          </div>

          <button
            type="button"
            class="filters-bar__filters-close"
            @click="closeFilters"
          >
            <icon-cross class="filters-bar__close-icon" />
          </button>
        </div>

        <div class="filters-bar__filters">
          <slot name="filters" />
        </div>
      </div>

      <div class="filters-bar__filters-buttons">
        <button
          type="button"
          class="filters-bar__filter-button"
          @click="closeFilters"
        >
          {{ $t('buttons.view_results') }}
        </button>

        <button
          type="button"
          class="filters-bar__clear-button"
          @click="clearFilters"
        >
          {{ $t('buttons.clear') }}
        </button>
      </div>
    </div>

    <span class="dashboard-filters__button-right">
      <slot name="button-right" />
    </span>
  </div>
</template>

<script>
import IconFilters from '~/icons/IconFilters'
import IconCross from '~/icons/IconCross'

export default {
  components: {
    IconCross,
    IconFilters,
  },

  data () {
    return {
      areFiltersActiveMobile: false 
    }
  },

  methods: {
    closeFilters () {
      this.areFiltersActiveMobile = false
    },

    openFilters () {
      this.areFiltersActiveMobile = true
    },

    clearFilters() {
      this.$emit('reset:filters')
    },
  }
}
</script>