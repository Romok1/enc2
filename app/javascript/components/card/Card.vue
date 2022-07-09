<template>
  <div class="card flex flex-v-start flex-column">
    <div
      class="card__img flex-vs-center flex-no-shrink bg-img"
      :style="imageStyling"
    />
    <div class="card__content">
      <h2 class="card__title h2">
        {{ card.title }}
      </h2>
      <p class="card__description">
        {{ card.content }}
      </p>
      <a
        class="card__button button--arrow"
        :href="$url(`${card.link}`)"
        :title="buttons_t.view_full_list"
      >
        {{ buttons_t.view_full_list }}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    card: {
      required: true,
      type: Object
    }
  },

  data () {
    return {
      buttons_t: this.$t('buttons')
    }
  },

  computed: {
    imageStyling () {
      return `background-image: url(${this.card.image})`
    }
  }
}
</script>
