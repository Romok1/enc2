<template>
  <div class="filters flex flex-column">
    <dataset
      v-for="(layer, index) in layersArray"
      :key="layer.id"
      :dataset-id="getDatasetId(index)"
      :layer="layer"
      :event="event"
      :accordion-item-active="accordionItemActive"
    />
  </div>
</template>

<script>
/**
 * A Facet component contains a list of datasets. When a facet is selected it should automatically open
 * the first dataset associated with it. If the facet is on an embedded map it will be the only facet shown
 * and so should also auto-opend the first dataset
 */
import Dataset from './Dataset.vue'

export default {
  name: 'Facet',

  components: { Dataset },

  props: {
    id: {
      type: [Number, String],
      required: true,
    },
    layers: {
      required: true,
      type: Array
    },
    toggleId: {
      type: String,
      default: ''
    },
    embedded: Boolean
  },

  data() {
    return {
      children: this.$children,
      event: 'toggleFilter-' + this.id,
      accordionItemActive: false
    }
  },

  computed: {
    layersArray() {
      return this.layers
    }
  },

  mounted() {
    if (this.toggleId != '') {
      this.$root.$on(this.toggleId, this.updateAccordionStatus)
    }
    if (this.embedded) {
      /** If we are embedded (on an asset/driver page) automatically open first dataset */
      this.$root.$emit('add-' + this.getDatasetId(0))
    }
  },

  methods: {
    getDatasetId (index) {
      return `dataset_${this.id}_${this.layers[index].id}_${this.layers[index].name}`.replace(/ /g, '_')
    },

    updateAccordionStatus(status) {
      this.accordionItemActive = status
      /** When this facet is expanded we should automatically show the first (available) dataset */
      if (status) {
        for (let ii = 0; ii < this.layers.length; ii++) {
          if (this.layers[ii].available) {
            this.$root.$emit('add-' + this.getDatasetId(ii))
            break
          }
        }
      }
    }
  }
}
</script>
