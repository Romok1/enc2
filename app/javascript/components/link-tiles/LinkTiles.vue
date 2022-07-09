<template>
  <div class="link-tiles">
    <ul class="link-tiles__items">
      <li
        v-for="tile in config"
        :key="tile.id"
        class="link-tiles__item"
      >
        <link-tile
          :tile="tile"
        />
      </li>
    </ul>
  </div>
</template>

<script>
import LinkTile from './LinkTile.vue'

export default {
  name: 'LinkTiles',

  components: {
    LinkTile
  },

  props: {
    config: {
      type: Array,
      default: () => []
    }
  }
}
</script>
