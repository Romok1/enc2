<template>
  <div :class="getModifiedClass('tabs')">
    <ul
      role="tablist"
      :class="getModifiedClass('tabs__triggers')"
      class="flex flex-nowrap ul--unstyled"
    >
      <li
        v-for="(child, index) in children"
        :id="triggerId(child)"
        :key="`tab-trigger-${_uid}-${index}`"
        role="tab"
        tabindex="0"
        :aria-controls="child.id"
        :aria-selected="child.isActive"
        :class="getTabTriggerClasses(child)"
        @keypress.enter.prevent="click(child)"
        @keypress.space.prevent="click(child)"
        @click="click(child)"
      >
        <div :class="getModifiedClass('tab__trigger-contents')">
          <label
            :for="child.id"
            class="no-margin hover--pointer"
            :class="getModifiedClass('tab__title')"
          >{{ child.title }}</label>
          <tooltip
            v-if="showHelpIcon"
            :text="child.tooltip"
          />
        </div>
      </li>
    </ul>
    <div :class="getModifiedClass('tab__container')">
      <slot />
    </div>
  </div>
</template>

<script>
import Tooltip from '~/components/tooltip/Tooltip'

export default {
  name: 'Tabs',
  components: {
    Tooltip
  },
  props: {
    showHelpIcon: {
      default: false,
      type: Boolean
    },
    initActiveId: {
      default: '',
      type: String
    },
    modifier:  {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      children: [],
      selectedId: ''
    }
  },

  mounted () {
    this.children = this.$children.filter(child => child.$options._componentTag === 'tab')
    this.initTabs()

    this.$root.$on('tabs-toggle', this.activateTab)
  },

  methods: {
    activateTab (tabId) {
      this.children.forEach(child => {
        child.isActive = child.id === tabId
      })
      this.selectedId = tabId
      this.$emit('tab-changed', tabId)
    },

    click (selectedChild) {
      this.activateTab(selectedChild.id)
    },

    getModifiedClass (className) {
      return this.modifier ? `${className}--${this.modifier}` : className
    },

    getTabTriggerClasses (child) {
      return [
        'flex-no-shrink button--unstyled hover--pointer',
        this.getModifiedClass('tab__trigger'),
        { 'active' : child.isActive }
      ]
    },

    initTabs () {
      this.children.forEach((child, index) => {
        child.isActive = this.initActiveId ?
          child.id === this.initActiveId :
          index === 0

        if (child.isActive) {
          this.selectedId = child.id
        }
      })
    },

    triggerId (child) {
      return 'tab-trigger-' + child.id
    }
  }
}
</script>
