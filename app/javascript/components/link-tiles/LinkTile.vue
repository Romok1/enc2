<template>
  <div
    class="link-tile"
    :class="{
      [`link-tile--${tile.id}`]: true,
      'link-tile--disabled': !tile.link.href
    }"
  >
    <div class="link-tile__header">
      <span
        v-if="tile.badge"
        class="link-tile__badge"
      >
        {{ tile.badge }}
      </span>
      <span class="link-tile__icon" />
    </div>
    <div class="link-tile__body">
      <h3 class="link-tile__title">
        {{ tile.title }}
      </h3>
      <p class="link-tile__text">
        {{ tile.body }}
      </p>
      <a
        :href="$url(tile.link.href)"
        :target="tile.link.external ? '_blank' : undefined"
        :title="`${tile.title} - ${tile.link.text}`"
        class="link-tile__link button--arrow"
        @click.right="onClick(tile, 'right')"
        @click.left="onClick(tile, 'left')"
        @click.middle="onClick(tile, 'middle')"
      >
        {{ tile.link.text }}
      </a>
    </div>
  </div>
</template>

<script>
import mixinGa from '~/mixins/mixin-ga'

export default {
  name: 'LinkTile',

  mixins: [mixinGa],

  props: {
    tile: {
      type: Object,
      default: () => ({})
    }
  },

  methods: {
    onClick (tile, mouseButton) {
      if (tile.id === 'ibat') {
        this.trackIBATLink('Tools', mouseButton)
      }
    }
  }
}
</script>
