<template>
  <ul>
    <tab-fake
      v-for="(child, index) in children" 
      :id="child.id"
      :key="index"
      :selected-id="selectedId"
      :title="child.title"
      @click:tab="click"
    />
  </ul>
</template>

<script>
import TabFake from './TabFake.vue'

export default {
  name: 'TabsFake',

  components: { TabFake },

  props: {
    children: {
      type: Array,
      required: true,
      validator: children => children.every(child =>
        ['id', 'title'].every(prop =>
          child.hasOwnProperty(prop) && typeof child[prop] === 'string'
        )
      ) 
    },
    defaultSelectedId: {
      default: '',
      type: String
    },
    preSelectedId: {
      default: '',
      type: String
    }
  },

  data () {
    return {
      defaultId: this.children[0].id,
      selectedId: ''
    }
  },

  created () {
    this.$root.$on('reset:tabs', this.reset)

    this.setInitialTab()
  },

  methods: {
    click (selectedId) {
      this.selectedId = selectedId

      this.$emit('click:tab', selectedId)
    },

    reset () {
      this.selectedId = this.defaultId
    },

    setInitialTab () {
      if(this.defaultSelectedId) {
        this.defaultId = this.defaultSelectedId
      }

      let tabId = this.defaultId

      if(this.preSelectedId !== '') {
        this.children.filter(child => {
          if(child.id === this.preSelectedId) {
            tabId = this.preSelectedId
          }
        })
      }

      this.selectedId = tabId
    }
  }
}
</script>
