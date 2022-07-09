<template>
  <div
    class="portfolios-card portfolios-card--create"
  >
    <div class="portfolios-card__content">
      <span class="portfolios-card__icon" />
      <h3 class="portfolios-card__title">
        {{ $t('portfolios.card.create_name') }}
      </h3>
      <p
        class="portfolios-card__link"
      >
        {{ $t('buttons.create') }}
      </p>
    </div>

    <button
      :title="$t('portfolios.card.create_link_title')"
      class="portfolios-card__fauxlink"
      @click="openPortfolioGenerator"
    />
  </div>
</template>

<script>
export default {
  methods: {
    openPortfolioGenerator () {
      this.$root.$emit('portfolio-generator-modal:open')
    } 
  }
}
</script>
