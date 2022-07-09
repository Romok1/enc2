<template>
  <div
    class="modal"
    :class="{ 'modal--active': active }"
  >
    <div class="modal__container">
      <div
        class="modal__close"
        @click="onCloseClick"
      />
      <div class="modal__content">
        <slot />
      </div>
    </div>
    <div
      class="modal__overlay"
      @click="onCloseClick"
    />
  </div>
</template>

<script>
export default {
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
      this.$root.$emit('modal:close')
      this.$emit('close')
    }
  }
}
</script>
