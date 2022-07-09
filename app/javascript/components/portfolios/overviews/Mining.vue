<template>
  <div class="portfolios-card__container">
    <p class="portfolios-card__heading">
      {{ $t(`portfolios.card.list.mining`) }}:
    </p>
    <ul
      v-for="(item, index) in overviewItems"
      :key="index"
      class="portfolios-card__items"
    >
      <li
        class="portfolios-card__item"
      >
        {{ item.company.name }}
      </li>
      <li
        v-if="showItemsCount(index)"
        class="portfolios-card__item"
      >
        {{ remainingItemCount }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    overview: {
      type: Array,
      required: true
    }
  },

  computed: {
    overviewItems () {
      return this.overview.slice(0, 3)
    },

    remainingItemCount () {
      return '...+' + (this.overview.length - 3)
    }
  },

  methods: {
    showItemsCount (index) {
      return this.overview.length > 3 && index === 2
    }
  }
}
</script>