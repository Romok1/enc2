<template>
  <div class="map-page">
    <VNav
      :is-always-burger="true"
      :pages="nav"
    >
      <MapToggles 
        slot="nav-left"
        :map-views="mapViews"
        :active-id-prop="selectedMapViewId"
        @update:selected="updateSelectedToggle" 
      />
      <template slot="nav-right">
        <slot name="map-nav-right" />
      </template>
    </VNav>

    <div class="map-container">
      <MapExplore
        id="map--explore"
        :mapbox-token="mapboxToken"
        :carto-username="cartoUsername"
        :carto-api-key="cartoApiKey"
      />

      <MapDisclaimer />

      <FilterPane
        id="filters-layers"
        :pane-text="filterPaneTextForView"
        :selected-option-id="selectedOptionId"
        :api-type="selectedMapViewId"
        :select-options="selectOptions"
      />
    </div>
  </div>
</template>

<script>
/**
 * MapPage contains the main components:
 * component and re-creating the side menu from that
 */
import FilterPane from '~/components/filters/FilterPane'
import MapDisclaimer from '~/components/map/MapDisclaimer'
import MapExplore from '~/components/map/Map'
import MapToggles from '~/components/map/MapToggles'
import VNav from '~/common/nav/VNav.vue'
import { DEPENDENCIES_ID, HOTSPOTS_ID, IMPACTS_ID } from '~/helpers/explore-helpers'

export default {
  components: {
    MapDisclaimer,
    MapExplore,
    MapToggles,
    FilterPane,
    VNav,
  },

  props: {
    nav: {
      required: true,
      type: Array
    },
    selectOptionsById: {
      default: () => {},
      type: Object
    },
    selectedOptionId: {
      type: Number,
      default: 0
    },
    view: {
      type: String,
      default: ''
    }
  },

  data() {
    return {
      mapboxToken:
        'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiRXg1RERWRSJ9.taTsSWwtAfFX_HMVGo2Cug',
      cartoUsername: 'carbon-tool',
      cartoApiKey: 'f7762e628586b3ff41a371b8e89ea0069e975299',
      filterPaneText: this.$t('map.filter_pane_text'),
      common_t: this.$t('common'),
      selectedMapViewId: this.view,
    }
  },

  computed: {
    selectOptions () {
      return this.selectOptionsById[this.selectedMapViewId] || []
    },

    filterPaneTextForView () {
      const text = { ...this.$t('map.filter_pane_text') }

      text.description = text.description[this.selectedMapViewId]

      return text
    },
    
    mapViews() {
      return [
        {
          id: DEPENDENCIES_ID,
          name: this.common_t.dependencies
        },
        {
          id: IMPACTS_ID,
          name: this.common_t.impacts
        },
        {
          id: HOTSPOTS_ID,
          name: this.common_t.hotspots
        }
      ]
    }
  },

  methods: {
    updateSelectedToggle (id) {
      this.selectedMapViewId = id
    }
  }
}
</script>
