<template>
  <div class="filters__container">
    <template v-for="filters in filtersArray">
      <template v-if="hasFacets(filters)">
        <h2 class="h3">
          {{ filters.name }}
        </h2>

        <accordion
          :id="accordionId(filters.name + '-subsets')"
          class="accordion--box"
        >
          <template v-for="(facet, index) in filters.facets">
            <h3 class="screen-reader">
              {{ facet.name }}
            </h3>
            <accordion-item 
              :id="accordionItemId()" 
              :key="toggleId(facet.name)" 
              :accordion-id="accordionId(filters.name + '-subsets')" 
              :title="facet.name" 
              :toggle-id="toggleId(facet.name)" 
              :has-modal="true" 
              :modal-content="facet.information"
            >
              <facet
                v-if="facet.layers.length"
                :id="facet.id"
                :key="index"
                :toggle-id="toggleId(facet.name)"
                :layers="facet.layers"
              />
            </accordion-item>
          </template>
        </accordion>
      </template>
      <template v-else>
        <facet
          :id="filters.id"
          :layers="filters.layers"
          :embedded="embedded"
        />
      </template>
    </template>
  </div>
</template>

<script>
/**
 * This component decides whether to build in the grouping or not - if the 'filtersArray' this component receives
 * has a sub-element called 'facets' then it uses the filtersArray to build the group menus and constructs
 * a facet component for each facet (this happens on main map page) Otherwise it uses filtersArray directly as the
 * facets (which happens on specific asset/driver pages)
 */

import helpers from '~/utilities/helpers.js'
import Accordion from '~/components/accordion/Accordion.vue'
import AccordionItem from '~/components/accordion/AccordionItem.vue'
import Facet from './Facet.vue'

export default {
  name: 'Filters',

  components: { Accordion, AccordionItem, Facet },

  props: {
    filters: {
      type: Array,
      default: () => []
    },
    embedded: Boolean
  },

  computed: {
    filtersArray() {
      return this.filters
    }
  },

  methods: {
    accordionId(name) {
      return 'acc-' + helpers.spacesToKebab(name)
    },

    accordionItemId() {
      return 'acc-item-' + helpers.randomNumber()
    },

    toggleId(name) {
      return 'filters-' + helpers.spacesToKebab(name)
    },

    hasFacets(filters) {
      return filters.facets
    }
  }
}
</script>
