<template>
  <div class="map-toggles">
    <button 
      v-for="view in mapViews"
      :key="view.id"
      class="map-toggles__toggle"
      :class="{'active': isActive(view)}"
      @click="updateSelected(view.id)"
    >
      {{ view.name }}
      <tooltip :text="tooltips[view.id]" />
    </button>
  </div>
</template>

<script>
import Tooltip from '../tooltip/Tooltip'

export default {
  components: { Tooltip },

  props: {
    mapViews: {
      type: Array,
      default: () => []
    },

    activeIdProp: {
      type: String,
      default: ''
    }
  },

  computed: {
    tooltips () {
      return this.$t('tooltips')
    },

    activeId: {
      get () {
        return this.activeIdProp
      },

      set (activeId) {
        this.$emit('update:selected', activeId)
      }
    }
  },

  created () {
    this.initActiveId()
  },

  mounted () {
    this.scrollSelectedIntoView()
  },

  methods: {
    isActive (view) {
      return view.id === this.activeId
    },

    updateSelected (id) {
      this.activeId = id
    },

    initActiveId () {
      this.activeId = this.activeIdProp || this.mapViews[0].id
    },

    scrollSelectedIntoView () {
      const padding = 16
      const activeToggle = this.$el.querySelector('.map-toggles__toggle.active')
      const scrollContainer = this.$el.parentElement
      const scrollBy = activeToggle.offsetLeft 
        - scrollContainer.offsetWidth 
        + padding 
        + activeToggle.offsetWidth 

      scrollContainer.scrollLeft = scrollBy
    }
  }
}
</script>