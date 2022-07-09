<template>
  <div class="ratings-records">
    <ul
      class="ratings-records__items"
      :class="{ 'ratings-records__items--collapsed': isCollapsed }"
    >
      <li
        v-for="record in rating.entities"
        :key="`${record.id}-${_uid}`"
        class="ratings-records__item"
      >
        <ratings-record
          v-bind="{ category, record }"
          :selected-rating="selectedRating"
        />
      </li>
    </ul>
    <button
      v-if="rating.entities.length > 5"
      class="ratings-records__button"
      @click="onClick"
    >
      {{ toggleText }}
    </button>
  </div>
</template>

<script>
import { mixinResponsive } from '~/mixins/mixin-responsive'
import RatingsRecord from './Record'

export default {
  components: {
    RatingsRecord
  },

  mixins: [ mixinResponsive ],

  props: {
    category: {
      type: String,
      required: true,
      validator: name => name.match(/impact_drivers|ecosystem_services/)
    },
    rating: {
      type: Object,
      required: true
    },
    selectedRating: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      isCollapsed: true
    }
  },

  computed: {
    shouldToggle () {
      return this.currentBreakpoint === 'small'
    },

    toggleText () {
      return this.isCollapsed
        ? this.$t('buttons.show_more')
        : this.$t('buttons.show_less')
    }
  },

  methods: {
    onClick () {
      this.isCollapsed = !this.isCollapsed
    }
  }
}
</script>
