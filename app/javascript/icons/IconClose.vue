<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 64 64"
    :class="data.staticClass"
    class="icon-close"
  >
    <g
      class="icon-close__background"
      :fill="props.fill"
      :stroke="props.stroke"
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
      class="icon-close__shape"
      :fill="props.color"
      d="M44.983 18.627a1.348 1.348 0 00-1.907 0L31.891 29.812 20.706 18.627a1.349 1.349 0 10-1.907 1.907l11.185 11.185-11.185 11.185a1.349 1.349 0 101.907 1.907l11.185-11.185 11.185 11.185a1.349 1.349 0 101.907-1.907L33.797 31.719l11.185-11.185a1.348 1.348 0 00.001-1.907z"
    />
  </svg>
</template>

<script>
export default {
  props: {
    color: {
      default: undefined,
      type: String,
    },
    fill: {
      default: undefined,
      type: String,
    },
    stroke: {
      default: undefined,
      type: String,
    }
  }
}
</script>
