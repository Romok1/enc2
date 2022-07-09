<template>
  <div
    class="filters__filter flex"
    :class="{ 'filter--active': isActive, 'filter--unavailable': !layer.available }"
  >
    <i
      class="filters__radio-button"
      @click="toggleFilter"
    />
    <div class="filters__filter-container">
      <div class="filters__filter-legend">
        <h4 class="filters__filter-title h3">
          {{ layer.name }} <em
            v-if="!layer.available"
            class="not-available-text"
          > - {{ common_t.not_available }}</em>
        </h4>
        <p class="filters__filter-description">
          {{ layer.description }}
        </p>
        
        <template v-if="layer.available">
          <div
            v-if="legend"
            class="filters__filter-legend__body"
          >
            <ul class="filters__filter-legend__items">
              <li
                v-for="(category, n) in legend"
                :key="category"
                class="filters__filter-legend__category"
              >
                <span
                  class="filters__filter-legend__colour"
                  :style="{'background-color': colors[n]}"
                />
                {{ category }}
              </li>
            </ul>
          </div>

          <div 
            v-else
            class="filters__filter-legend__body"
          >
            <div
              class="filters__filter-legend__gradient"
              :style="legendGradient"
            />

            <div class="filters__filter-legend__labels flex flex-h-between">
              <span>{{ ratings_t.l }}</span>
              <span>{{ ratings_t.h }}</span>
            </div>
          </div>

          <a
            v-if="layer.url"
            class="filters__filter-legend__link a--underline"
            :href="layer.url"
            title="Visit data resource"
            target="_blank"
            @click.stop
          >{{ buttons_t.link_resource }}<i class="icon-chevron-right" /></a>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
/**
 * This component holds the box for a specific datasets. It controls whether or not it is
 * visible by events that are received by Map.vue that shows/hides individual layers
 */
export default {
  name: 'Layer',

  props: {
    datasetId: {
      required: true,
      type: String
    },
    layer: {
      required: true,
      type: Object
    },
    event: {
      required: true,
      type: String
    },
    accordionItemActive: Boolean
  },

  data() {
    return {
      selected: false,
      layerAdded: false,
      common_t: this.$t('common'),
      buttons_t: this.$t('buttons'),
      ratings_t: this.$t('ratings'),
    }
  },

  computed: {
    isActive() {
      return this.selected && this.layer.available
    },

    colors () {
      return JSON.parse(this.layer.colors)
    },

    filters () {
      return JSON.parse(this.layer.filters)
    },

    legend () {
      return this.layer.legend ? JSON.parse(this.layer.legend) : null
    },

    legendGradient() {
      return {
        background: `linear-gradient(to right, ${this.colors.join(', ')})`
      }
    }
  },

  watch: {
    accordionItemActive() {
      if (!this.accordionItemActive) {
        this.toggleFilter(false)
      }
    }
  },

  mounted() {
    if (this.layer.available) {
      this.$root.$on('map-reload-layers', this.reloadLayer)
      this.$root.$on('remove-' + this.datasetId, this.removeLayer)
      this.$root.$on('add-' + this.datasetId, this.addLayer)
    }
  },

  destroyed() {
    this.$root.$off('map-reload-layers', this.reloadLayer)
  },

  methods: {
    reloadLayer(isStyleLoaded) {
      this.loadLayer(true, isStyleLoaded)
    },

    loadLayer(forceAdd, isStyleLoaded) {
      if ((this.layer.available && isStyleLoaded) || forceAdd) {
        this.toggleLayer(false, forceAdd)
      }
    },

    toggleFilter(boolean) {
      if (typeof boolean == 'boolean') {
        this.selected = boolean
      } else {
        this.selected = !this.selected
      }

      this.toggleLayer(true)
      this.$root.$emit(this.event)
    },

    toggleLayer(pan, forceAdd) {
      if (!this.layerAdded || forceAdd) {
        this.createDataset(this.selected)
      }
      if (this.selected) {
        this.showLayer(pan)
      } else {
        this.hideLayer()
      }
    },

    createDataset(selected) {
      if (this.layer.available) {
        this.layerAdded = true
        /** raster datasets contain just one layer to show */
        if (!this.filters.length) {
          this.$root.$emit('map-create-layer', {
            isMapbox: !this.layer.tileset.match(/^http/),
            name: this.datasetId,
            opacity: this.layer.opacity,
            tileset: this.layer.tileset,
            type: this.layer.map_type,
            visible: selected
          })
        } else {
          /** Vector datasets contain multiple layers....*/
          for (let ii = 0; ii < this.filters.length; ii++) {
            let layer = {
              filter: this.filters[ii],
              cartoTables: [this.layer.carto_table],
              colour: this.colors[ii],
              id: this.datasetId + '_' + ii,
            }

            if (this.layer.tileset) {
              layer.tileset = this.layer.tileset
            }

            if (this.layer.source_layer) {
              layer.sourceLayer = this.layer.source_layer
            }

            this.$root.$emit('map-create-layer', {
              name: layer.id,
              type: this.layer.map_type,
              visible: selected,
              ...layer,       
            })
          }
        }
      }
    },

    addLayer() {
      this.selected = true
      this.toggleLayer()
    },

    showLayer() {
      if (!this.filters.length) {
        this.$root.$emit('map-show-layer', this.datasetId)
      } else {
        for (let ii = 0; ii < this.filters.length; ii++) {
          this.$root.$emit('map-show-layer', this.datasetId + '_' + ii)
        }
      }
      this.$root.$emit('map-set-curr', this.datasetId)
    },

    removeLayer() {
      this.selected = false
      this.hideLayer()
    },

    hideLayer() {
      if (!this.filters.length) {
        this.$root.$emit('map-hide-layer', this.datasetId)
      } else {
        for (let ii = 0; ii < this.filters.length; ii++) {
          this.$root.$emit('map-hide-layer', this.datasetId + '_' + ii)
        }
      }
    }
  }
}
</script>
