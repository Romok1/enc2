<template functional>
  <div
    class="field"
    v-bind="data.attrs"
    :style="data.staticStyle"
    :class="[
      data.staticClass,
      {
        'field--invalid': $options.hasErrors(props.error),
      }
    ]"
  >
    <slot />
  </div>
</template>
<script>
export default {
  props: {
    error: {
      type: Boolean,
      default: undefined
    }
  },
  hasErrors (error) {
    return error === true
  }
}
</script>