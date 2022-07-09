<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 64 64"
    :class="data.staticClass"
  >
    <g
      fill="none"
      :stroke="props.color"
    >
      <circle
        cx="32"
        cy="32"
        r="32"
        stroke="none"
      />
      <circle
        cx="32"
        cy="32"
        r="31.5"
      />
    </g>
    <path
      d="M39.421 46.707L24.85 32.135l14.571-14.571"
      fill="none"
      :stroke="props.color"
      stroke-miterlimit="10"
      stroke-width="3"
    />
  </svg>
</template>

<script>
export default {
  props: {
    color: {
      default: '#000',
      type: String
    }
  }
}
</script>
