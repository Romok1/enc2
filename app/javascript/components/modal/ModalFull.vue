<template>
  <div
    class="modal-full"
    :class="{ 'modal-full--active': active }"
  >
    <div class="modal-full__top-left">
      <slot name="topleft" />
    </div>

    <div class="modal-full__top-right">
      <button
        class="modal-full__button"
        @click="onCloseClick"
      >
        <icon-close />
      </button>
    </div>

    <div class="modal-full__body">
      <div class="modal-full__content">
        <slot name="body" />
      </div>
    </div>
    <slot name="footer" />
  </div>
</template>

<script>
import IconClose from '~/icons/IconClose'

export default {
  components: {
    IconClose
  },

  model: {
    event: 'changed',
    prop: 'active'
  },

  props: {
    active: {
      type: Boolean,
      required: true
    }
  },

  methods: {
    onCloseClick () {
      this.$emit('changed', false)
    }
  }
}
</script>
