<template>
  <div>
    <slot />
  </div>
</template>
<script>
export default {
  props: {
    state: {
      default: () => ({}),
      type: Object
    }
  },
  created () {
    this.$store.replaceState({
      ...this.$store.state,
      ...this.state
    })
  }
}
</script>