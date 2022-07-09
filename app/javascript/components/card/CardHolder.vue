<template>
  <div class="card-holder flex-center">
    <card
      v-for="(card, index) in cards"
      :key="index"
      :card="card"
    />
  </div>
</template>

<script>
import Card from './Card'

export default {
  components: {
    Card
  },

  props: {
    cards: {
      required: true,
      type: Array
    }
  }
}
</script>

