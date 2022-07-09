<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="66"
    height="84"
    viewBox="0 0 66 84"
    :class="data.staticClass"
  >
    <g 
      transform="translate(-17 -8)" 
      :stroke="color"
    >
      <path
        d="M26,92H74a9.01,9.01,0,0,0,9-9V50a9.01,9.01,0,0,0-9-9V29A21.023,21.023,0,0,0,53,8H47A21.023,21.023,0,0,0,26,29V41a9.01,9.01,0,0,0-9,9V83A9.01,9.01,0,0,0,26,92Zm6-63A15.017,15.017,0,0,1,47,14h6A15.017,15.017,0,0,1,68,29V41H32ZM23,50a3,3,0,0,1,3-3H74a3,3,0,0,1,3,3V83a3,3,0,0,1-3,3H26a3,3,0,0,1-3-3Z"
      />
      <path
        d="M44,62a6,6,0,1,1,9,5.166V74a3,3,0,0,1-6,0V67.166A5.98,5.98,0,0,1,44,62Z"
      />
    </g>
  </svg>
</template>

<script>
export default {
  props: {
    color: {
      default: '#000000',
      type: String,
    },
  },
};
</script>
