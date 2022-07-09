<template>
  <explore-content-list
    :items="items" 
    :is-category-active="true"
    :get-factsheet-path="getFactsheetPath"
    :get-map-path="getMapPath"
    :show-assets="false"
    :join-model="impactsId"
    @update:item-count="updateExploreContentCount($event)"
  />
</template>

<script>
import ExploreContentList from './ExploreContentList'
import { IMPACTS_ID, IMPACTS_IMPACT_DRIVERS_ID } from '~/helpers/explore-helpers'
import { getImpactsMapURl } from '~/helpers/request-helpers'

export default {
  components: {
    ExploreContentList,
  },

  props: {
    items: {
      type: Array,
      default: () => []
    },

    getFactsheetPath: {
      type: Function,
      required: true
    }
  },

  data () {
    return {
      impactsId: IMPACTS_ID,
      getMapPath: getImpactsMapURl
    }
  },

  methods: {
    updateExploreContentCount (count) {
      this.$store.commit(
        'explore/updateExploreContentCounts',
        {
          vm: this,
          id: IMPACTS_IMPACT_DRIVERS_ID,
          count
        }
      )
    }
  }
}
</script>
