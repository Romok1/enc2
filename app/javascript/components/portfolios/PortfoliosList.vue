<template>
  <div class="portfolios-list">
    <div class="portfolios-list__header">
      <h2 class="portfolios-list__title">
        {{ $t('portfolios.title') }}
      </h2>
      <div class="portfolios-list__search">
        <input
          v-model.trim="name"
          type="text"
          class="portfolios-list__search-bar"
          :placeholder="$t('portfolios.search.placeholder')"
        >
      </div>
    </div>
    <div class="portfolios-list__body">
      <cards v-bind="{ filters: { name } }" />
    </div>
  </div>
</template>

<script>
import Cards from './Cards'

export default {
  components: {
    Cards
  },

  data () {
    return {
      name: undefined
    }
  }
}
</script>
