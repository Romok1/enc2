<template>
  <div class="ratings-indicators">
    <ul class="ratings-indicators__items">
      <li
        v-for="rating in data.materialities"
        :key="`${rating.name}-${_uid}`"
        class="ratings-indicators__item"
        :class="{ 'ratings-indicators__item--selected': isSelected(rating) }"
        @click="onClick(rating)"
      >
        <ratings-indicator
          v-bind="{ category, rating }"
          :max-count="data.maxCount"
          :selected="isSelected(rating)"
        />
      </li>
    </ul>
  </div>
</template>

<script>
import { ratingHasEntities } from '~/helpers/application-helpers'
import RatingsIndicator from './Indicator'

export default {
  components: {
    RatingsIndicator
  },

  model: {
    prop: 'selectedRating',
    event: 'changed'
  },

  props: {
    category: {
      type: String,
      required: true,
      validator: name => name.match(/impact_drivers|ecosystem_services/)
    },
    data: {
      type: Object,
      required: true
    },
    selectedRating: {
      type: String,
      default: ''
    }
  },

  methods: {
    isSelected (rating) {
      return rating.name === this.selectedRating
    },

    onClick (rating) {
      if (!this.isSelected(rating) && ratingHasEntities(rating)) {
        this.$emit('changed', rating.name)
      }
    }
  }
}
</script>
