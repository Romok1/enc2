<template functional>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="100%"
    height="100%"
    viewBox="0 0 82 82"
  >
    <g
      id="Group_311"
      data-name="Group 311"
      transform="translate(-5 -5)"
    >
      <path
        id="Path_86"
        :fill="props.color"
        data-name="Path 86"
        d="M5,37.618V20.58C32.06,20.58,59.94,5,87,5V22.038c-27.06,0-54.94,15.58-82,15.58"
        transform="translate(0)"
      />
      <path
        id="Path_87"
        :fill="props.color"
        data-name="Path 87"
        d="M5,59.2c27.06,0,54.94,15.58,82,15.58V91.818c-27.06,0-54.94-15.58-82-15.58V59.2"
        transform="translate(0 -4.818)"
      />
      <path
        id="Path_88"
        :fill="props.color"
        data-name="Path 88"
        d="M5,57.564V40.8H87V57.564H5"
        transform="translate(0 -3.182)"
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
  },
}
</script>
