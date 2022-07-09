<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="100%"
    height="100%"
    viewBox="0 0 97.96 61.777"
    :class="data.staticClass"
  >
    <g
      id="Group_537"
      data-name="Group 537"
      transform="translate(-117.741 -389.13)"
    >
      <path
        id="Path_555"
        data-name="Path 555"
        d="M120.741,392.13h64.394v22.213h3V389.13H117.741v51.734h33.7v7.043H139.5v3h27.259v-3H154.438v-7.043h15.657v-3H120.741Z"
        :fill="props.color"
      />
      <path
        id="Path_556"
        data-name="Path 556"
        d="M212.7,421.35H177.1v29.4h38.6v-29.4Zm0,26.4H180.1v-23.4h32.6Z"
        :fill="props.color"
      />
      <rect
        id="Rectangle_2271"
        data-name="Rectangle 2271"
        width="3"
        height="5.5"
        transform="translate(185.134 433.5)"
        :fill="props.color"
      />
    </g>
  </svg>
</template>

<script>
export default {
  props: {
    color: {
      default: '#161615',
      type: String,
    },
  },
}
</script>
