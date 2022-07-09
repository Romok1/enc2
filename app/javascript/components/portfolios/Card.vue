<template>
  <div
    class="portfolios-card"
    :class="`portfolios-card--${portfolio.portfolio_type}`"
  >
    <button
      class="portfolios-card__delete"
      @click="onDeleteClick"
    >
      {{ $t('common.delete') }}
    </button>
    <div class="portfolios-card__content">
      <span class="portfolios-card__icon" />
      <h3 class="portfolios-card__title">
        {{ portfolio.name }}
      </h3>
      <component
        :is="component"
        :overview="portfolio.overview"
      />
      <p
        class="portfolios-card__link"
      >
        {{ $t('buttons.view') }}
      </p>
    </div>
    <a
      :href="$url(portfolio.path)"
      :title="$t('portfolios.card.link_title')"
      class="portfolios-card__fauxlink"
    />
  </div>
</template>

<script>
import OverviewsAgriculture from './overviews/Agriculture'
import OverviewsMining from './overviews/Mining'
import OverviewsNaturalCapital from './overviews/NaturalCapital'

export default {
  components: {
    OverviewsAgriculture,
    OverviewsMining,
    OverviewsNaturalCapital,
  },

  props: {
    portfolio: {
      type: Object,
      required: true
    }
  },

  computed: {
    component () {
      return `overviews-${this.portfolio.portfolio_type.replace('_', '-')}`
    }
  },

  methods: {
    onDeleteClick () {
      this.$root.$emit('show-portfolios-delete-modal', {
        show: true,
        portfolio: this.portfolio
      })
    }
  }
}
</script>
