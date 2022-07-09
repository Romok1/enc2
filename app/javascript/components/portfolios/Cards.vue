<template>
  <component
    :is="carousel ? 'carousel' : 'div'"
    v-if="hasPortfolios"
    :options="{
      autoPlay: false,
      cellSelector: '.portfolios-list__item',
      pageDots: false
    }"
    :class="{
      'portfolios-list__carousel': carousel
    }"
  >
    <div class="portfolios-cards">
      <ul class="portfolios-list__items">
        <li
          v-for="portfolio in portfolios"
          :key="`${portfolio.id}-${_uid}`"
          class="portfolios-list__item"
        >
          <card
            v-bind="{ portfolio }"
          />
        </li>
      </ul>
    </div>
    <delete-modal
      @deleted="loadPortfolios"
    />
  </component>
  <div
    v-else
    class="portfolios-cards"
  >
    <ul class="portfolios-list__items">
      <li class="portfolios-list__item">
        <card-empty />
      </li>
      <li class="portfolios-list__item">
        <card-create />
      </li>
    </ul>
  </div>
</template>

<script>
import { debounce } from 'lodash'
import Carousel from '~/components/carousel/Carousel'
import Card from './Card'
import CardCreate from './CardCreate'
import CardEmpty from './CardEmpty'
import DeleteModal from '~/components/portfolios/DeleteModal'

export default {
  components: {
    Carousel,
    Card,
    CardCreate,
    CardEmpty,
    DeleteModal
  },

  props: {
    carousel: {
      type: Boolean,
      default: false
    },
    filters: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      portfolios: undefined
    }
  },

  computed: {
    hasPortfolios () {
      return this.portfolios && this.portfolios.length
    }
  },

  watch: {
    filters: {
      deep: true,
      handler: debounce(function () {
        this.loadPortfolios()
      }, 150)
    }
  },

  created () {
    this.loadPortfolios()
  },

  methods: {
    loadPortfolios () {
      this.$http.get(`/${this.$i18n.locale}/portfolios`, {
        params: this.filters
      })
        .then(response => {
          this.portfolios = response.data
        })
    }
  }
}
</script>
