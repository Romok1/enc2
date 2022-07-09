import { isTabForward, isTabBackward } from '~/helpers/focus-helpers'
import { KEYCODES } from '~/helpers/keyboard-helpers'
import { UNDEFINED_ID } from '~/helpers/explore-helpers'

import mixinPopupCloseListeners from './mixin-popup-close-listeners'


export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect', clickAreaSelector: '.v-select__click-area'}),
  ],

  props: {
    placeholder: {
      default: '',
      type: String
    }
  },

  data () {
    return {
      isActive: false,
      highlightedOptionIndex: -1,
      searchTerm: '',
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id,
      selectControlId: 'v-select-search-' + this.config.id,
      selectDropdownToggleId: 'v-select-dropdown-' + this.config.id,
      searchResetId: 'v-select-search-reset-' + this.config.id
    }
  },

  computed: {
    container () {
      return this.$el.querySelector('#'+ this.dropdownId)
    },
    
    hasKeyboardFocus () {
      return this.highlightedOptionIndex >= 0
    },

    highlightedOptionId () {
      if (this.isActive && this.filteredOptions.length && this.hasKeyboardFocus) {
        return this.getOptionInputId(this.filteredOptions[this.highlightedOptionIndex])
      }

      return null
    },

    isDisabled () {
      return !this.options.length
    },

    placeholderText () {
      return this.placeholder || `- ${this.$t('buttons.enter')} -`
    },

    toggleLabel () {
      return this.config.toggleLabel || 
        this.selectedOptionsString ||
        this.placeholderText
    },

    showOptions () {
      return this.isActive && Boolean(this.filteredOptions.length)
    },

    showSearch () {
      return this.config.hasSearch && !this.config.iconOnly
    },

    showToggle () {
      return !this.config.hasSearch && !this.config.iconOnly
    },

    showResetIcon () {
      return this.config.hasSearch && 
        this.config.showSearchIcons && 
        this.searchTerm && 
        this.isActive
    },

    showSearchIcon () {
      return this.config.hasSearch &&
        this.config.showSearchIcons &&
        !this.showResetIcon
    },

    translations () {
      return this.$t('filters')
    },

    controlElement () {
      const controlElement = this.$el.querySelector('#' + this.selectControlId)

      if (controlElement) { return controlElement }

      return this.$el.querySelector('#' + this.selectDropdownToggleId)
    },

    dropdownToggleTabIndex () {
      return this.config.iconOnly ? 0 : -1
    },

    searchResetElement () {
      return this.$el.querySelector('#' + this.searchResetId)
    }
  },

  watch: {
    searchTerm () {
      this.resetHighlightedIndex()
    },

    highlightedOptionId (id) {
      if (id !== null) {
        this.scrollToHighlightedOption()
      }
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  mounted () {
    this.addTabFromSearchListener()
    this.addArrowKeyListeners()
    this.addTabForwardFromResetListener()
  },

  methods: {
    onToggleFocus () {
      if (this.config.iconOnly) {
        this.openSelect()
      }
    },

    toggleSelect (e) {
      if (this.options.length && !this.isActive) {
        this.openSelect(e)
      } else {
        this.closeSelect(e)
      }
    },

    openSelect () {
      this.resetSearchTerm()
      
      if (this.filteredOptions.length > 0) {
        this.isActive = true
      }
    },

    isHighlighted (index) {
      return index === this.highlightedOptionIndex
    },

    resetHighlightedIndex() {
      this.highlightedOptionIndex = -1
    },

    getOptionFromId (id) {
      const filteredOptions = this.options.filter( option => {
        return option.id == id
      })

      return filteredOptions.length ? filteredOptions[0] : null
    },

    getOptionInputId (option) {
      const friendlyId = option.id.toString().replace(/[ ()]/g, '-')

      return `option-${this.config.id}-${friendlyId}`
    },

    matchesSearchTerm (option) {
      const regex = new RegExp(`${this.searchTerm}`, 'i')
      const match = option.name.toString().match(regex)

      return !this.searchTerm || match
    },

    emitSelection () {
      this.$emit('update:selected-option', this.selectedInternal)
    },

    resetSearchTermClick () {
      this.resetSearchTerm()
      this.focusSearch()
    },

    focusSearch () {
      this.controlElement.focus()
    },

    resetSearchTerm () {
      this.searchTerm = ''
    },

    setSearchTermToSelectionMessage () {
      if (this.config.toggleLabel) {
        this.searchTerm = this.config.toggleLabel
      } else if (this.selectedInternal == UNDEFINED_ID) {
        this.searchTerm = this.placeholderText
      } else {
        this.searchTerm = this.selectedOptionsString
      }
    },

    scrollToHighlightedOption () {
      const highlightedOption = this.$el.querySelector('#' + this.highlightedOptionId)

      this.container.scrollTop = highlightedOption.offsetTop    
    },

    conditionalOptionClasses (option, index) {
      return {
        'highlighted': this.isHighlighted(index),
        'selected': this.isSelected(option)
      }
    },

    getSearchLabel (filterConfig) {
      return `${filterConfig.label} ${this.$t('buttons.search')}`
    },

    addTabFromSearchListener () {
      this.controlElement.addEventListener('keydown', e => {
        if (isTabBackward(e)) {
          this.closeSelect()
        } else if (isTabForward(e) && !this.showResetIcon) {
          this.closeSelect()
        }
      })
    },

    addTabForwardFromResetListener () {
      if (this.searchResetElement) {
        this.$el.querySelector('#' + this.searchResetId).addEventListener('keydown', e => {
          if (isTabForward(e)) {
            this.closeSelect()
          }
        })
      }
    },

    addArrowKeyListeners () {
      this.controlElement.addEventListener('keydown', e => {
        switch (e.keyCode) {
        case KEYCODES.down:
          this.incremementKeyboardFocus()
          e.preventDefault()
          break
        case KEYCODES.up:
          this.decrementKeyboardFocus()
          e.preventDefault()
          break
        case KEYCODES.enter:
          if(this.filteredOptions.length && this.hasKeyboardFocus) {
            this.clickOption(this.filteredOptions[this.highlightedOptionIndex])
          }
          e.preventDefault()
          break
        case KEYCODES.esc:
          document.activeElement.blur()
          break
        }
      })
    },

    incremementKeyboardFocus () {
      if (this.highlightedOptionIndex === this.filteredOptions.length - 1) {
        this.highlightedOptionIndex = 0
      } else {
        this.highlightedOptionIndex++
      }
    },

    decrementKeyboardFocus () {
      if (this.highlightedOptionIndex === 0) {
        this.highlightedOptionIndex = this.filteredOptions.length - 1
      } else if (this.hasKeyboardFocus) {
        this.highlightedOptionIndex--
      }
    }
  },
}
