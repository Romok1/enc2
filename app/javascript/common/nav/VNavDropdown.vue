<template>
  <div
    class="nav__dropdown"
    :class="{'nav__dropdown--active': isActive}"
  >
    <button 
      :id="mixinTriggerId"
      aria-haspopup="true"
      :aria-expanded="isActive"
      :aria-controls="mixinModalId"
      class="nav__dropdown-toggle hover--pointer flex-inline flex-v-center button--unstyled no-padding"
      @click="toggleDropdown"
    >
      <label
        :for="mixinModalId"
        :title="truncate(item.label) === item.label ? item.label : undefined"
        class="nav__select nav__select--dropdown hover--pointer no-margin"
      >
        {{ truncate(item.label) }}</label>
      <span class="select__drop-arrow nav__drop-arrow arrow-svg--white" />
    </button>
    <div class="nav__dropdown-wrapper">
      <menu
        :id="mixinModalId"
        class="nav__dropdown-menu ul--unstyled"
        :class="{'nav__dropdown-menu--two-col': hasTwoColumns}"
      >
        <v-nav-link
          v-for="dropdownItem in item.children"
          :key="dropdownItem.id"
          class="nav__dropdown-item"
          :item="dropdownItem"
        />
      </menu>
    </div>
  </div>
</template>

<script>
import { truncate } from 'lodash'
import VNavLink from './VNavLink'
import mixinFocusCapture from '~/mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '~/mixins/mixin-popup-close-listeners'

const TRUNCATE_THRESHOLD = 24

export default {
  components: {
    VNavLink
  },

  mixins: [
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeDropdown', openCallback: 'openDropdown'}),
    mixinPopupCloseListeners({closeCallback: 'closeDropdown'})
  ],

  props: {
    item: {
      required: true,
      type: Object
    },
    isBurger: {
      required: true,
      type: Boolean
    }
  },

  data() {
    return {
      isActive: false
    }
  },

  computed: {
    hasTwoColumns () {
      return !this.isBurger && this.item.children.length > 4
    },

    mixinModalId () {
      return `nav-dropdown-${this.item.id}`
    },

    mixinTriggerId () {
      return `nav-dropdown-toggle-${this.item.id}`
    }
  },

  methods: {
    truncate (text) {
      return truncate(text, {
        length: TRUNCATE_THRESHOLD
      })
    },

    closeDropdown () {
      this.isActive = false
    },
    openDropdown () {
      this.isActive = true
    },
    toggleDropdown (e) {
      this.isActive ? this.closeDropdown(e) : this.openDropdown(e)
    }
  }
}
</script>