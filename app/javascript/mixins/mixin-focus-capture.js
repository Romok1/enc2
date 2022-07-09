import { getInputs, preventTab, TAB_KEYCODE } from '~/helpers/focus-helpers'

export default ({toggleVariable, closeCallback, openCallback}) => ({
  data() {
    return {
      firstInput: null,
      lastInput: null,
      modalElement: null
    }
  },

  created () {
    if(closeCallback) {
      const originalCloseCallback = this[closeCallback]

      this[closeCallback] = e => {
        originalCloseCallback()
        document.activeElement.blur()
        this.forgetModal()

        if (e && !e.detail) {
          this.mixinFocusTriggerElementIfExists()
        }
      }
    }

    if(openCallback) {
      const originalOpenCallback = this[openCallback]
  
      this[openCallback] = e => {
        originalOpenCallback()

        this.$nextTick(() => {
          document.activeElement.blur()
          this.addEventListeners()
  
          if (e && !e.detail) {
            this.mixinFocusFirstInputIfExists()
          }
        })
      }
    }
  },

  mounted () {
    if(this[toggleVariable]) {
      this.addEventListeners()
    }
  },

  beforeDestroy() {
    this.forgetModal()
  },

  watch: {
    [toggleVariable] (isExpanded) {
      if (isExpanded && !openCallback) {
        this.$nextTick(() => {
          document.activeElement.blur()
          this.addEventListeners()
          this.mixinFocusFirstInputIfExists()
        })
      } else if (!isExpanded && !closeCallback) {

        document.activeElement.blur()
        this.forgetModal()

        this.mixinFocusTriggerElementIfExists()
      }
    }
  },

  computed: {
    triggerElement () {
      if (this.mixinTriggerId) {
        return document.querySelector('#' + this.mixinTriggerId)
      }

      return null
    }
  },

  methods: {
    addEventListeners() {
      this.setModalElements()
      if (!this.firstInput) { return }

      const isRadioGroup = this.mixinIsRadioGroup !== undefined ? this.mixinIsRadioGroup : false
  
      if (isRadioGroup) {
        this.modalElement.addEventListener('keydown', preventTab)
      } else {
        this.lastInput.addEventListener('keydown', this.handleLastInputTab)
        this.firstInput.addEventListener('keydown', this.handleFirstInputTab)
      }
    },

    forgetModal () {
      this.removeEventListeners()
      this.resetModalElements()
    },

    removeEventListeners () {
      if (this.modalElement) { this.modalElement.removeEventListener('keydown', preventTab) }
      if (this.firstInput) { this.firstInput.removeEventListener('keydown', this.handleFirstInputTab) }
      if (this.lastInput) { this.lastInput.removeEventListener('keydown', this.handleLastInputTab) }
    },
    
    setModalElements() {
      this.modalElement = this.mixinModalId ? document.querySelector('#' + this.mixinModalId) : this.$el
      this.setInputs()
    },
    
    setInputs () {
      const inputs = getInputs(this.modalElement)
      
      this.firstInput = inputs[0]
      this.lastInput = inputs[inputs.length - 1]
    },
    
    resetModalElements() {
      this.modalElement = this.firstInput = this.lastInput = null
    },

    handleFirstInputTab (e) {
      if (e.keyCode === TAB_KEYCODE && e.shiftKey) {
        e.preventDefault()
        this.mixinFocusLastInputIfExists()
      }
    },

    handleLastInputTab (e) {
      if (e.keyCode === TAB_KEYCODE && !e.shiftKey) {
        e.preventDefault()
        this.mixinFocusFirstInputIfExists()
      }
    },

    mixinFocusLastInputIfExists () {
      if (this.lastInput) {
        this.lastInput.focus()
      }
    },

    mixinFocusFirstInputIfExists () {
      if (this.firstInput) {
        this.firstInput.focus()
      }
    },

    mixinFocusTriggerElementIfExists () {
      if (this.triggerElement) {
        this.triggerElement.focus()
      }
    }
  }
})