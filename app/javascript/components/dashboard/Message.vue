<template>
  <div class="dashboard-message">
    <div class="dashboard-message__icon">
      <slot name="icon" />
    </div>

    <p class="dashboard-message__title">
      {{ text.title }}
    </p>

    <p 
      v-if="text.description"
      class="dashboard-message__description"
    >
      {{ text.description }}
    </p>
  </div>
</template>

<script>
const validateTextProp = text => {
  const validTitle = text.title && typeof text.title === 'string'
  const validDescription = text.description ? typeof text.description === 'string' : true

  return validTitle && validDescription
}

export default {
  props: {
    text: {
      type: Object,
      required: true,
      validator: validateTextProp
    }
  }
}
</script>