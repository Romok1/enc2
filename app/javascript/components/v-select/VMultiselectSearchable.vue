<template>
  <div
    class="v-select v-select--search v-select--multi relative"
    :class="{
      'disabled': isDisabled, 
      'active': isActive,
      'v-select--icon': config.iconOnly
    }"
  >
    <input
      :id="config.id"
      v-model="selectedInternal"
      type="hidden"
      :name="config.id"
    >

    <div
      v-if="config.label"
      class="v-select__label"
    >
      <label
        :for="toggleId"
        class="v-select__selection"
      >{{ config.label }}</label>
      <slot name="label-icon" />
    </div>

    <label 
      :for="selectedOptionsId"
      class="screen-reader"
    >
      {{ translations.selected_options }}
    </label>

    <ul
      v-show="showSelectedList && selectedInternal.length"
      :id="selectedOptionsId" 
      class="v-select__selected-options flex flex-wrap"
      role="listbox" 
    >
      <li
        v-for="(option, index) in selectedInternal"
        :key="getUniqueVForKey('selected-option', index)"
        role="option"
      >
        <button 
          class="v-select__selected-option hover--pointer"
          @click.stop.prevent="deselectOption(option)"
        >
          {{ option.name }}
        </button>
      </li>
    </ul>

    <div class="v-select__click-area">
      <div class="v-select__search relative">
        <template v-if="showSearch">
          <label
            class="screen-reader"
            :for="selectControlId"
          >{{ getSearchLabel(config) }}</label>

          <input
            :id="selectControlId"
            v-model="searchTerm"
            class="v-select__search-input"
            type="search"
            role="combobox"
            aria-haspopup="listbox"
            aria-autocomplete="list"
            autocomplete="off"
            :aria-expanded="showOptions.toString()"
            :aria-owns="dropdownId"
            :aria-activedescendant="highlightedOptionId" 
            :placeholder="placeholderText"
            :disabled="isDisabled"
            @focus="openSelect"
          >
        </template>

        <button 
          v-if="showToggle"
          :id="selectControlId"
          class="v-select__toggle"
          aria-haspopup="listbox"
          :aria-expanded="showOptions.toString()"
          :aria-owns="dropdownId"
          :aria-activedescendant="highlightedOptionId" 
          :disabled="isDisabled"
          @click.stop.prevent="openSelect"
          @focus="openSelect"
        >
          {{ toggleLabel }}
        </button>

        <span 
          v-show="showSelectedCount"
          class="v-select__selected-count"
        >
          {{ selectedInternal.length }}
        </span>

        <span class="v-select__search-icons">
          <span
            v-show="showSearchIcon"
            class="v-select__search-icon"
          />
          <button 
            v-show="showResetIcon"
            :id="searchResetId"
            class="v-select__search-icon--reset hover--pointer"
            @click.stop.prevent="resetSearchTermClick"
          />
          <button
            :id="selectDropdownToggleId"
            class="v-select__drop-arrow select__drop-arrow"
            type="button" 
            :tabindex="dropdownToggleTabIndex"
            @mousedown="toggleSelect"
            @focus="onToggleFocus"
          />
        </span>
      </div>

      <div
        v-show="showOptions"
        class="v-select__dropdown-wrapper"
      >
        <ul 
          :id="dropdownId" 
          role="listbox" 
          class="v-select__dropdown"
        >
          <li
            v-for="(option, index) in filteredOptions"
            v-show="matchesSearchTerm(option)"
            :id="getOptionInputId(option)"
            :key="getUniqueVForKey('select-option', index)"
            :class="['v-select__option hover--pointer', conditionalOptionClasses(option, index)]"
            role="option"
            :aria-selected="isHighlighted(index).toString()"
            @click.stop.prevent="clickOption(option)"
          >
            <span class="flex-no-shrink v-select__checkbox" />
            <span>{{ option.name }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'
import mixinSelectShared from '../../mixins/mixin-select-shared'

export default {
  mixins: [
    mixinIds,
    mixinSelectShared
  ],

  model: {
    event: 'update:selected-option',
    prop: 'selected'
  },

  props: {
    config: {
      required: true,
      type: Object
    },
    options: {
      default: () => [],
      type: Array
    },
    selected: {
      type: Array,
      default: () => []
    },
    showSelectedList: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      selectedInternal: [],
    }
  },

  computed: {
    filteredOptions () { 
      return this.options.filter(option => {
        const isSelectedAndSelectedListShown = this.showSelected && !this.isSelected(option)

        return this.matchesSearchTerm(option) && !isSelectedAndSelectedListShown
      })
    },

    selectedOptionsId () {
      return `${this.getComponentId()}-selected-options`
    },

    selectedOptionsString () {
      const selectedNames = this.options
        .filter(this.isSelected)
        .map(option => option.name)

      return selectedNames.length ? selectedNames.join(', ') : ''
    },

    showSelectedCount () {
      const hideSelectedCount = this.config.showSelectedCount !== undefined && 
        !this.config.showSelectedCount

      return !hideSelectedCount && this.selectedInternal.length 
    }
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption === null ?
        [] :
        newSelectedOption
    }
  },

  methods: {
    closeSelectAndFocusSearch () {
      this.closeSelect()
      this.focusSearch()
    },

    closeSelect () {
      this.setSearchTermToSelectionMessage()
      this.resetHighlightedIndex()
      this.isActive = false
    },

    focusSearch () {
      this.$el.querySelector('#' + this.selectControlId).focus()
    },

    initializeSelectedInternal () {
      this.setSearchTermToSelectionMessage()

      if (this.selected === null) {
        this.selectedInternal = []
      } else {
        this.selectedInternal = this.selected
      }
    },

    isSelected (option) {
      let isSelected = false
      
      this.selectedInternal.forEach(selectedOptionId => {
        if (selectedOptionId === option.id) {
          isSelected = true
        }
      })

      return isSelected
    },

    clickOption (option) {
      if (this.showSelectedList) {
        this.selectOption(option)
      } else {
        this.isSelected(option) ? this.deselectOption(option) : this.selectOption(option)
      }
    },

    selectOption (option) {
      this.selectedInternal.push(option.id)

      const unselectedOptionsLength = this.filteredOptions.length

      if (unselectedOptionsLength === 0) {
        this.resetHighlightedIndex()
        this.closeSelectAndFocusSearch()
      } else if (this.highlightedOptionIndex >  unselectedOptionsLength - 1) {
        this.highlightedOptionIndex--
      }

      this.emitSelection()
    },

    resetSearchTerm () {
      this.searchTerm = ''
    },

    deselectOption (deselectedOption) {
      this.selectedInternal = this.selectedInternal.filter(optionId => optionId !== deselectedOption.id )
      this.emitSelection()
    }
  }
}
</script>