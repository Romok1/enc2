<template>
  <div
    :class="[
      'ratings-indicator',
      { 'ratings-indicator--selected': selected },
      { 'ratings-indicator--disabled': !ratingHasEntities(rating) }
    ]"
  >
    <span
      :class="[
        'ratings-indicator__rating',
        ratingClass
      ]"
    />
    <h5 class="ratings-indicator__heading">
      {{ indicatorText }}
    </h5>
    <bar :bar="getBarConfig()" />
  </div>
</template>

<script>
import { getRatingClass, ratingHasEntities } from '~/helpers/application-helpers'
import Bar from '../Bar'

export default {
  components: {
    Bar
  },

  props: {
    category: {
      type: String,
      default: undefined
    },
    maxCount: {
      type: Number,
      default: 0
    },
    rating: {
      type: Object,
      required: true
    },
    selected: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    indicatorText () {
      return this.$t(
        `natural_capital.dashboard.components.${this.category}_list.indicator_text`,
        {
          count: this.rating.entities.length,
          maxCount: this.maxCount
        }
      )
    },

    ratingClass () {
      return getRatingClass(this.rating.name, this.$i18n.locale)
    }
  },

  methods: {
    getBarConfig () {
      return {
        classModifier: this.category,
        maxValue: this.maxCount,
        value: this.rating.entities.length
      }
    },

    ratingHasEntities (rating) {
      return ratingHasEntities(rating)
    }
  }
}
</script>
