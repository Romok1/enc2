<template>
  <li 
    :class="['tab__trigger', { 'active': isActive }]"
    @click="click"
    v-html="title"
  />
</template>

<script>
export default {
  name: 'TabFake',

  props: {
    id: {
      type: String,
      required: true
    },
    selectedId: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    }
  },

  computed: {
    isActive () {
      return this.id === this.selectedId
    }
  },

  methods: {
    click () {
      this.$emit('click:tab', this.id)
    }
  }
}
</script>
