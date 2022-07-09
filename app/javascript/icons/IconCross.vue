<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 25.799 25.799"
    :class="data.staticClass"
  >
    <g
      :fill="props.fill"
      stroke-miterlimit="10"
      stroke-width="3"
    >
      <path
        :stroke="props.color"
        d="M1.061 1.061l23.677 23.677"
      />
      <path
        :stroke="props.color"
        d="M24.738 1.061L1.061 24.738"
      />
    </g>
  </svg>
</template>

<script>
export default {
  props: {
    color: {
      default: '#000',
      type: String,
    },
    fill: {
      default: '#424242',
      type: String,
    }
  },
}
</script>
