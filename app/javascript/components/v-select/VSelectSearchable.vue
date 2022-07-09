<template>
  <div
    class="v-select v-select--search relative"
    :class="{
      active: isActive,
      disabled: isDisabled,
      'v-select--icon': config.iconOnly
    }"
  >
    <input
      :id="config.id"
      :value="selectedInternal"
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

    <div class="v-select__click-area">
      <div class="v-select__search relative">
        <template v-if="showSearch">
          <label
            class="screen-reader"
            :for="selectControlId"
          >
            {{ getSearchLabel(config) }}
          </label>

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

        <span class="v-select__search-icons">
          <span
            v-show="showSearchIcon"
            class="v-select__search-icon"
          />
          <button
            v-show="showResetIcon"
            :id="searchResetId"
            type="button"
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
            :class="['v-select__option', conditionalOptionClasses(option, index)]"
            role="option"
            :aria-selected="isHighlighted(index).toString()"
            @click.stop.prevent="clickOption(option)"
          >
            <span class="flex-no-shrink v-select__radio" />
            <span>{{ option.name }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'
import mixinSelectShared from '~/mixins/mixin-select-shared'
import { UNDEFINED_ID } from '~/helpers/explore-helpers.js'

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
      default: '',
      type: [Number, String]
    }
  },

  data () {
    return {
      selectedInternal: null,
      buttons_t: this.$t('buttons')
    }
  },

  computed: {
    filteredOptions () {
      return this.options.filter(this.matchesSearchTerm)
    },

    selectedOptionsString () {
      const selectedOption = this.getOptionFromId(this.selectedInternal)

      return selectedOption ? selectedOption.name : ''
    }
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption === null ?
        this.UNDEFINED_ID :
        newSelectedOption
      this.setSearchTermToSelectionMessage()
    }
  },

  methods: {
    closeSelect () {
      this.setSearchTermToSelectionMessage()
      this.resetHighlightedIndex()
      this.isActive = false
    },

    initializeSelectedInternal () {
      if (this.selected === null) {
        this.selectedInternal = UNDEFINED_ID
      } else {
        this.selectedInternal = this.selected
        this.setSearchTermToSelectionMessage()
      }
    },

    isSelected (option) {
      return option.id === this.selectedInternal
    },

    clickOption (option) {
      this.selectOption(option)
    },

    selectOption (option) {
      this.selectedInternal = option.id
      this.closeSelect()
      document.activeElement.blur()
      this.emitSelection()
    }
  }
}
</script>
