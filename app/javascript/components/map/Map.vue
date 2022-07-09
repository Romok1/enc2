
<template>
  <div
    :id="id"
    class="map"
  />
</template>

<script>
/**
 * MapExplore is the main map panel and most of the functionality comes from this component and mixin-carto
 * This component handles 'mapbox, carto, and arcgis map services' on the map and knows nothing about our 'datasets' which may contain
 * multiple layers
 * Handled services are Vector Tile Service, WMS, ArcGIS MapServer and mapbox raster tiles
 * Key events:
 *   map-create-layer: creates a single map layer with given id
 *   map-show-layer: show the layer with provided id (must already have been created)
 *   map-hide-layer: hide the layer with provided id (must already have been created)
 *
 */
import { mixinCarto } from '~/mixins/mixin-carto.js'

import LayersControl from '~/utilities/layers-control.js'
import { mixinResponsive } from '~/mixins/mixin-responsive.js'
import { getFirstForegroundLayerId } from '~/helpers/map-helpers'

export default {
  mixins: [mixinCarto, mixinResponsive],

  props: {
    isEmbedded: {
      type: Boolean,
      default: false
    },
    mapboxToken: {
      type: String,
      required: true
    },
    cartoUsername: {
      type: String,
      required: true
    },

    cartoApiKey: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      currentLayerId: undefined,
      firstForegroundLayerId: ''
    }
  },

  computed: {
    id() {
      return this.isEmbedded ? 'map--embedded' : 'map--explore'
    }
  },

  mounted() {
    this.$root.$on('map-create-layer', this.createLayer)
    this.$root.$on('map-show-layer', this.showLayer)
    this.$root.$on('map-hide-layer', this.hideLayer)
    this.$root.$on('map-set-curr', this.setLayer)

    mapboxgl.accessToken = this.mapboxToken

    const map = new mapboxgl.Map({
      container: this.id,
      style: 'mapbox://styles/unepwcmc/cknip0poi0p9g17o1m3nzs0h7',
      pitchWithRotate: false,
      center: [0, 30],
      zoom: 1,
      scrollZoom: !this.isEmbedded
    })

    this.map = map

    /** This event is for when mapbox style is changed on e.g. to 'streets' or 'basic'
     * so we reload all layers on the new map
     */
    map.on('style.load', () => {
      this.setFirstForegroundLayerId()
      this.$root.$emit('map-reload-layers', map.isStyleLoaded())
    })

    map.on('load', () => {
      const navControl = new mapboxgl.NavigationControl()
      const layersControl = new LayersControl()

      const geocoderControl = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
        flyTo: true,
        zoom: false
      })

      /** mapBox specific controls */
      map.addControl(layersControl, 'bottom-left')
      map.addControl(navControl, 'bottom-left')
      map.addControl(geocoderControl, 'top-left')
      this.setFirstForegroundLayerId()
    })
  },

  methods: {
    setFirstForegroundLayerId() {
      this.firstForegroundLayerId = getFirstForegroundLayerId(this.map)
    },

    createLayer(layer) {
      if (layer.type === 'Raster') {
        this.createRasterLayer(layer)
      } else {
        this.createVectorLayer(layer)
      }
    },

    createRasterLayer(layer) {
      const source = {
        type: 'raster',
        tileSize: this.getTileSize(layer),
      }

      if (layer.isMapbox) {
        source.url = `mapbox://${layer.tileset}`
      } else {
        source.tiles = [layer.tileset]
      }

      this.map.addLayer(
        {
          id: layer.name,
          type: 'raster',
          source,
          paint: { 'raster-opacity': layer.opacity || 1 },
          layout: { visibility: layer.visible ? 'visible' : 'none' }
        },
        this.firstForegroundLayerId
      )
    },

    getTileSize (layer) {
      if (
        layer.type === 'Raster' && 
        layer.tileset &&
        layer.tileset.match('data-gis.unep-wcmc')
      ) {
        return 128
      }

      return 256
    },

    createVectorLayer(layer) {
      if (layer.cartoTables.length && layer.cartoTables[0] !== null) {
        this.addCartoVectorLayer(layer)
      } else {
        this.addVectorLayer(layer)
      }
    },

    addVectorLayer (layer) {
      this.map.addLayer(
        {
          ...this.getVectorLayerOptions(layer),
          source: {
            type: 'vector',
            tiles: [layer.tileset]
          },
          'source-layer': layer.sourceLayer,
          filter: isNaN(layer.filter) ? ['all'] : ['==', '_symbol', Number(layer.filter)]
        },
        this.firstForegroundLayerId
      )
    },

    addCartoVectorLayer (layer) {
      const tiles = this.createCartoTiles(layer)

      tiles.getTiles(() => {
        this.map.addLayer(
          {
            ...this.getVectorLayerOptions(layer),
            source: {
              type: 'vector',
              tiles:
                tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
            },
            'source-layer': 'layer0'
          },
          this.firstForegroundLayerId
        )
      })
    },
    
    getVectorLayerOptions (layer) {
      const layout = { visibility: layer.visible ? 'visible' : 'none' }
      const options = { id: layer.id, layout }

      if (layer.type === 'VectorLine') {
        options.type = 'line'
        options.paint = { 'line-width': 3, 'line-color': layer.colour }
      } else if (layer.type === 'VectorCircle') {
        options.type = 'circle'
        options.paint = {
          'circle-radius': [
            'interpolate',
            ['exponential', 1],
            ['zoom'],
            0, 2,
            6, 4
          ],
          'circle-color': layer.colour
        }
      } else {
        options.type = 'fill'
        options.paint = { 'fill-color': layer.colour, 'fill-opacity': layer.opacity || 0.8 }
      }

      return options
    },

    createCartoTiles(layer) {
      /** Use mixin to create the tiles, passing it our user/key */
      return this.createTiles(this.cartoUsername, this.cartoApiKey, layer)
    },

    showLayer(layerId) {
      if (this.map.getLayer(layerId)) {
        this.map.setLayoutProperty(layerId, 'visibility', 'visible')
      }
    },

    setLayer(layerId) {
      if (this.currentLayerId !== layerId) {
        this.$root.$emit('remove-' + this.currentLayerId)
      }

      this.currentLayerId = layerId
    },

    hideLayer(layerId) {
      if (this.map.getLayer(layerId)) {
        this.map.setLayoutProperty(layerId, 'visibility', 'none')
      }
    }
  }
}
</script>