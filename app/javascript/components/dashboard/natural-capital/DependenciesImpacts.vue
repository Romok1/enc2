<template>
  <stats
    :tiles="dependenciesAndAssetsTiles"
    :header-text="dependenciesImpactsT"
  />
</template>

<script>
import Stats from './Stats'

export default {
  components: { Stats },

  props: {
    data: {
      type: Object,
      default: () => ({})
    }
  },

  computed: {
    dependenciesAndAssetsTiles () {
      const tiles = [
        {
          ...this.dependenciesImpactsT.services,
          ...this.data.ecosystemServices,
          category: 'ecosystem_services'
        },
        {
          ...this.dependenciesImpactsT.impact_drivers,
          ...this.data.impactDrivers,
          category: 'impact_drivers'
        },
      ]

      return this.getDependenciesAndAssetsTiles(tiles)
    },

    dependenciesImpactsData () {
      return this.data.dependenciesAndImpactsComponent
    },

    dependenciesImpactsT () {
      return this.$t('natural_capital.dashboard.components.main_dependencies_and_impacts')
    },
  },

  methods: {
    getDependenciesAndAssetsTiles (tiles) {
      tiles.forEach(tile => {
        tile.text = this.getParagraph(tile)
      })

      return tiles
    },

    getParagraph (tile) {
      return tile.text
        .replace('%{n}', `<strong>${tile.items.length}</strong>`)
    }
  }
}
</script>
