<template>
  <div class="success-feedback">
    <div class="success-feedback__container">
      <icon-tick
        class="success-feedback__icon"
        color="black"
      />
      <div class="success-feedback__heading">
        <slot name="heading" />
      </div>
      <div class="success-feedback__body">
        <slot name="body" />
      </div>
      <slot name="cta" />
    </div>
  </div>
</template>
<script>
import IconTick from '~/icons/IconTick.vue'

export default {
  components: {
    IconTick
  }
}
</script>