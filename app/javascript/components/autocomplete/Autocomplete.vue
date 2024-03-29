<template>
  <div class="autocomplete__container">
    <div
      class="autocomplete"
      @focus="focusInput"
    >
      <input
        ref="input"
        class="autocomplete__input"
        type="text"
        :disabled="disabled"
        :placeholder="placeholder"
        :value="search"
        @input="onInput"
        @keyup.enter.prevent.stop="onInputEnter"
        @keyup.esc.prevent.stop="onEscape"
      >

      <span class="autocomplete__search-icons">
        <button
          v-if="search"
          class="autocomplete__delete"
          @click="onDeleteClick"
        />
        <button
          v-else
          class="autocomplete__magnifying-glass"
          @click="onMagnifyingGlassClick"
        />
      </span>
    </div>
    <div
      v-show="showResultsPane"
      class="autocomplete__results-container"
    >
      <div class="autocomplete__results">
        <div 
          v-show="frontendError"
          class="autocomplete__error-message"
        >
          {{ frontendError }}
        </div>
        
        <div
          v-for="(result, index) in results"
          ref="results"
          :key="index"
          class="autocomplete__result"
          tabindex="0"
          :disabled="disabled"
          @click="submit(result)"
          @keyup.enter.stop.prevent="submit(result)"
          @mouseover="onResultMouseover"
        >
          {{ result.name }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { debounce } from 'lodash'
import ErrorBag from '~/classes/ErrorBag'
import eventHandler from '../../mixins/mixin-element-event-handler'

export default {
  name: 'Autocomplete',

  mixins: [
    /**
     * Determine if a tab keyup occurred outside of the component.
     * If it did, reset the component.
     * @return void
     */
    eventHandler(document, 'keyup', function (e) {
      if (e.key.toLowerCase() === 'tab') this.onFocusCheck()
    }),

    /**
     * Determine if a click occurred outside of the component.
     * If it did, reset the component.
     * @return void
     */
    eventHandler(document, 'click', function () {
      this.onFocusCheck()
    })
  ],

  props: {
    /**
     * The autocomplete depends on a callback to fetch its results.
     * The callback should be a function with a parameter for the search term.
     * It should return a Promise that resolves to an array of strings.
     */
    autocompleteCallback: {
      type: Function,
      required: true
    },

    errorMessages: {
      type: Object,
      required: true
    },

    disabled: {
      type: Boolean,
      default: false
    },

    /**
     * The placeholder to be seen before any input has been entered.
     */
    placeholder: {
      default: '...',
      type: String,
      required: false
    },

    resetEventName: {
      default: 'autocompleteReset',
      type: String
    }
  },

  data () {
    return {
      /**
       * To be used to prevent parallel calls to the autocomplete callback.
       * @type Boolean
       */
      busy: false,

      /**
       * Container for errors.
       * @type ErrorBag
       */
      errors: new ErrorBag,

      /**
       * MUST BE AN ARRAY OF LABEL/VALUE OBJECTS.
       * @type Array
       */
      results: [],

      /**
       * The search term. Replaced by an autocomplete result when selected.
       * @type String
       */
      search: '',

      /**
       * Mainly used when the component loses focus so that the results are not
       * cleared and can be shown again when the component is back in focus.
       * @type Boolean
       */
      shouldShowResults: false,
    }
  },

  computed: {
    frontendError () {
      if (this.errorTooShort) {
        return this.errorMessages.invalid_search_string
      } else if (this.errorNoResults) {
        return this.errorMessages.no_results
      }

      return ''
    },

    errorTooShort () {
      return !this.hasResults && !this.isValidSearchString
    },
    errorNoResults () {
      return !this.hasResults && this.isValidSearchString
    },
    hasResults () {
      return this.results.length > 0
    },
    hasSearchString () {
      return this.search.length > 0
    },
    isValidSearchString () {
      return this.search.length >= 2
    },
    showResultsPane () {
      return this.hasSearchString && this.shouldShowResults === true
    }
  },

  methods: {
    onEscape () {
      this.reset()
    },

    /**
     * Don't remove the results only if the component loses focus.
     * @return void
     */
    onFocusCheck () {
      this.shouldShowResults = this.$el.contains(document.activeElement)
    },

    /**
     * When [enter] is triggered by the input, focus on the first result 
     * so it can be used on the next trigger if there are any.
     * If there are no results then submit the search.
     * @return void
     */
    onInputEnter () {
      if (this.hasSearchString) {
        if (this.hasResults) {
          this.$refs.results[0].focus()
        } else {
          this.resetErrors({
            no_results: [this.errorMessages.no_results]
          })
        }
      }
    },

    /**
     * When the search icon is clicked, search if there's a term and there
     * aren't autocomplete results. Otherwise focus the input.
     * Focus the first result if they are available.
     * @return void
     */
    onMagnifyingGlassClick () {
      if (this.hasSearchString) {
        if (this.hasResults) {
          this.$refs.results[0].focus()
        } else {
          this.submit()
        }
      } else {
        this.focusInput()
      }
    },

    onDeleteClick () {
      this.reset()
    },

    onInput (e) {
      this.updateSearch(e.target.value)
      if (this.hasSearchString) {
        this.autocomplete()
      } else {
        this.resetAutocompleteResults()
      }
    },

    reset () {
      this.resetErrors()
      this.resetAutocompleteResults()
      this.updateSearch('')
    },

    resetErrors (errors) {
      this.errors = new ErrorBag(errors)
    },

    onResultMouseover (e) {
      if (!this.disabled) {
        e.target.focus()
      }
    },

    resetAutocompleteResults () {
      this.results = []
    },

    focusInput () {
      this.$refs.input.focus()
    },

    updateSearch (value) {
      this.search = value
    },

    /**
     * Run the [autocompleteCallback] function and expect it
     * to return a Promise that resolves to an array of [result] strings.
     * @return void
     */
    autocomplete: debounce(function () {
      if (this.busy) return
      if (!this.isValidSearchString) {
        this.resetErrors({
          invalid_search_string: [this.errorMessages.invalid_search_string]
        })

        return
      }
      this.busy = true
      const searchTerm = this.search

      this.resetErrors()
      this.autocompleteCallback(searchTerm).then(res => {
        const results = res.data

        /**
         * If the term has changed since fetching results, skip to final callback...
         */
        if (this.search !== searchTerm) {
          return
        }

        this.results = results

        if (results.length === 0) {
          this.resetErrors({
            no_results: [this.errorMessages.no_results]
          })
        }

        setTimeout(() => this.focusInput(), 0)
      }).catch(e => {
        console.error({ e })
        this.resetAutocompleteResults()
      }).finally(() => {
        this.busy = false
        /**
         * If the term has changed since fetching results, prepare to search again...
         */
        if (this.search !== searchTerm) {
          this.resetAutocompleteResults()
          this.autocomplete()

          return
        }
      })
    }, 500),

    /**
     * When used, this will submit a result.
     * 
     * @param result
     * @return void
     */
    submit (result) {
      if (!this.disabled) {
        this.busy = true
        this.updateSearch('')
        this.resetAutocompleteResults()
        this.$emit('submit', result)
        this.busy = false
      }
    }
  }
}
</script>