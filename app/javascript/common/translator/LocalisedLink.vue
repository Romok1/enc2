<template functional>
  <a
    v-bind="data.attrs"
    :class="data.staticClass"
    :style="data.staticStyle"
    :href="parent.$url(props.url)"
    :title="props.title"
  >
    <slot />
  </a>
</template>

<script>
export default {
  props: {
    url: {
      default: '',
      type: String
    },
    title: {
      default: '',
      type: String
    }
  }
}
</script>
