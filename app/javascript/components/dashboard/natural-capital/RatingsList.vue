<template>
  <pane
    :title="t.title"
    class="dashboard-pane--customScrollbar"
  >
    <div class="ratings-list">
      <div class="ratings-list__header">
        <h4 class="ratings-list_heading">
          {{ t.heading }}
        </h4>
        <p class="ratings-list__text">
          {{ t.intro }}
        </p>
      </div>
      <div class="ratings-list__body">
        <div class="ratings-list__columns">
          <div class="ratings-list__column">
            <ratings-indicators
              v-model="selectedRating"
              v-bind="{ data }"
              :category="category"
            />
          </div>
          <div
            class="ratings-list__column"
          >
            <div class="ratings-list__selected">
              <strong>{{ $t('common.selected') }}:</strong> <span :class="['ratings-list__selected-rating', ratingClass]" /> {{ getRatingPhrase(selectedRating) }}
            </div>
            <ratings-records
              v-bind="{
                category,
                rating: selectedRatingRecords,
                selectedRating
              }"
            />
          </div>
        </div>
      </div>
    </div>
  </pane>
</template>

<script>
import { getRatingClass, ratingHasEntities } from '~/helpers/application-helpers'
import Pane from '~/components/dashboard/Pane'
import RatingsIndicators from './ratings/Indicators'
import RatingsRecords from './ratings/Records'

export default {
  name: 'RatingsList',

  components: {
    Pane,
    RatingsIndicators,
    RatingsRecords
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
    }
  },

  data () {
    return {
      selectedRating: undefined
    }
  },

  computed: {
    ratingClass () {
      return getRatingClass(this.selectedRating, this.$i18n.locale)
    },

    selectedRatingRecords () {
      return this.data.materialities.find(rating => rating.name === this.selectedRating)
    },

    t () {
      return this.$t(`natural_capital.dashboard.components.${this.category}_list`)
    }
  },

  created () {
    const firstPopulatedRating = this.data.materialities.find(rating => ratingHasEntities(rating))

    this.selectedRating = firstPopulatedRating ? firstPopulatedRating.name : undefined
  },

  methods: {
    getRatingPhrase (rating) {
      return this.$t('ratings.materiality_rating')[rating.toLowerCase()]
    }
  }
}
</script>
