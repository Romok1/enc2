<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="9.596"
    height="7.5"
    viewBox="0 0 9.596 7.5"
    :class="data.staticClass"
  >
    <g transform="translate(0 -10.918)">
      <path
        class="a"
        :style="{
          fill: props.color
        }"
        d="M3.371,15.9l4.98-4.98L9.6,12.193,3.371,18.418,0,15.048l1.275-1.275Z"
      />
    </g>
  </svg>
</template>
<style scoped>
.a {
  fill-rule: evenodd;
}
</style>
<script>
export default {
  props: {
    color: {
      default: '#ffffff',
      type: String
    }
  }
}
</script>