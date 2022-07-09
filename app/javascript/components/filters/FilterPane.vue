<template>
  <div :class="['filter-pane', paneTargetClasses]">
    <div class="filter-pane__content gutters flex flex-column">
      <h1 class="filter-pane__title h3">
        {{ paneText.title }}
      </h1>
      <h2
        v-if="!hasFilters"
        class="h4 no-margin"
      >
        {{ paneText.title }}<em class="not-available-text"> - {{ common_t.not_available }}</em>
      </h2>
      <p
        v-if="paneText.description"
        class="filter-pane__description no-margin"
        v-html="paneText.description"
      />

      <template v-if="selectOptions.length">
        <v-select-searchable
          class="filter-pane__select"
          :config="{
            id: 'ecosystem-services',
            label: common_t.e_services,
            hasSearch: true
          }"
          :options="selectOptions"
          :selected="selectedOptionId"
          @update:selected-option="selectOption"
        >
          <tooltip
            slot="label-icon"
            :text="mapFilterTooltip"
          />
        </v-select-searchable>

        <span class="filter-pane__divider" />
      </template>

      <span 
        v-else
        class="filter-pane__divider--tablet-up" 
      />

      <template v-if="hasFilters">
        <filters
          :filters="filtersArray"
          :embedded="embedded"
        />
        <div class="filter-pane__gradient-indicator" />
      </template>
    </div>

    <div class="filter-pane__close-tab">
      <button
        class="button--plain filter-pane__close-button"
        @click.prevent="togglePane"
      />
    </div>
  </div>
</template>

<script>
/**
 * Top-level component of the menu system
 * Makes the api call to get menu items from backend and builds menu
 * Fires events paneOpened and paneClosed when the menu is hidden/revealed
 */

import helpers from '~/utilities/helpers.js'
import { mixinResponsive } from '~/mixins/mixin-responsive.js'
import Filters from './Filters.vue'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'
import Tooltip from '~/components/tooltip/Tooltip'
import { DEPENDENCIES_ID } from '~/helpers/explore-helpers'

export default {
  name: 'FilterPane',

  components: { Filters, Tooltip, VSelectSearchable },

  mixins: [mixinResponsive],

  props: {
    id: {
      type: String,
      required: true
    },
    selectedDriverOrAssetId: {
      type: Number,
      default: 0
    },
    selectedOptionId: {
      type: Number,
      default: 0
    },
    selectOptions: {
      type: Array,
      default: () => []
    },
    apiType: {
      type: String,
      required: true
    },
    embedded: {
      type: Boolean,
      default: false
    },
    paneText: {
      default: () => {},
      type: Object
    }
  },

  data() {
    return {
      isActive: false,
      filtersArray: [],
      common_t: this.$t('common'),
      map_t: this.$t('map'),
      selectedOptionIdInternal: null
    }
  },

  computed: {
    mapFilterTooltip () {
      return this.$t('tooltips.map_filter')
    },

    localeId () {
      return this.$i18n.locale
    },

    paneTargetClasses() {
      return {
        'filter-pane--active': this.isActive,
        'filter-pane--empty': !this.hasFilters,
        'filter-pane--embedded': this.embedded,
        [`filter-pane--${this.apiType}`]: true
      }
    },

    hasFilters() {
      if (this.embedded) {
        return this.filtersArray.length ? this.filtersArray[0].layers.length : false
      }

      return true
    }
  },

  watch: {
    currentBreakpoint () {
      this.initActiveState()
    },

    apiType () {
      this.reload()
    },
  },

  created() {
    const event = 'triggerPaneOpen-' + helpers.spacesToKebab(this.id)

    this.$root.$on(event, this.openPane)
    this.$root.$on('triggerPaneClose', this.closePane)
    this.updateOption(this.selectedOptionId)
    this.reload()
    this.initActiveState()
  },

  destroyed() {
    const event = 'triggerPaneOpen-' + helpers.spacesToKebab(this.id)

    this.$root.$off(event, this.openPane)
    this.$root.$off('triggerPaneClose', this.closePane)
    this.$root.$off('getNewItems', this.updateSites)
  },

  methods: {
    initActiveState() {
      this.isLarge() ? this.openPane() : this.closePane()
    },

    openPane() {
      this.isActive = true
      this.$root.$emit('paneOpened')
    },

    closePane() {
      this.isActive = false
      this.$root.$emit('paneClosed')
    },

    togglePane() {
      this.isActive ? this.closePane() : this.openPane()
    },

    selectOption(optionId) {
      this.updateOption(optionId)
      this.reload()
    },

    updateOption (optionId) {
      this.selectedOptionIdInternal = optionId
    },

    reload() {
      this.filtersArray = []
      let url = `/${this.localeId}/map/${this.apiType}`

      if (this.apiType === DEPENDENCIES_ID) {
        if (!this.selectedOptionIdInternal) { return }

        url += `?id=${this.selectedOptionIdInternal}`
      } else if (this.selectedDriverOrAssetId) {
        url += `?id=${this.selectedDriverOrAssetId}`
      }

      this.$http
        .get(url)
        .then(res => {
          this.filtersArray = res.data
        })
        .catch(err => {
          console.error(err)
        })
    }
  }
}
</script>
