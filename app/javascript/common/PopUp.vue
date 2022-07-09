<template>
  <div class="pop-up">
    <button
      v-if="hasTrigger"
      class="pop-up__open button--unstyled no-padding"
      @click.prevent="openPopUp"
    >
      <slot name="trigger--open" />
    </button>
    <div
      :class="['screen-overlay pop-up__modal', {'pop-up__modal--active': active}]"
      @close-pop-up="closePopUp"
    >
      <div
        ref="pop-up"
        class="pop-up__wrapper"
      >
        <button
          class="pop-up__close icon-close button--unstyled no-padding"
          @click.prevent="closePopUp"
        />
        <div
          v-if="active"
          class="pop-up__scroll-wrapper"
        >
          <slot name="pop-up" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import eventHandler from '~/mixins/mixin-element-event-handler'

export default {
  mixins: [
    eventHandler(window, 'click', function (e) {
      this.$nextTick(() => {
        if (this.active && this.$refs['pop-up'] && !this.$refs['pop-up'].contains(e.target)) {
          this.closePopUp()
        }
      })
    }),

    eventHandler(window, 'keyup', function (e) {
      setTimeout(() => {
        switch (e.key) {
        case 'Tab':
          if (!this.$el.contains(document.activeElement)) {
            this.closePopUp()
          }
          break
        case 'Escape':
          this.closePopUp()
          break
        }
      }, 0)
    })
  ],

  model: {
    event: 'change',
    prop: 'active'
  },

  props: {
    active: {
      type: Boolean,
      default: undefined
    },
    id: {
      type: String,
      default: undefined
    }
  },

  computed: {
    hasTrigger () {
      return Boolean(this.$slots['trigger--open'])
    }
  },

  created () {
    this.$root.$on('pop-up:close', this.onClosePopUpEvent)
    this.$root.$on('pop-up:open', this.onOpenPopUpEvent)
  },

  mounted () {
    this.withPopupTriggers(el => {
      el.addEventListener('click', this.onTriggerClick)
    })
  },

  beforeDestroy () {
    this.withPopupTriggers(el => {
      el.removeEventListener('click', this.onTriggerClick)
    })
  },

  methods: {
    closePopUp () {
      this.$emit('change', false)
      this.$emit('closed', this.id)
      this.$root.$emit('popup-closed', this.id)
    },

    isTriggerId(id) {
      return id === this.id
    },

    onClosePopUpEvent (id) {
      if (undefined === id || this.isTriggerId(id)) {
        this.closePopUp()
      }
    },

    /**
     * Permit control of this popup programmatically if you define it's id
     * and emit an event with it's matching ID over "pop-up:open".
     *
     * @param id string
     * @return void
     */
    onOpenPopUpEvent (id) {
      if (this.isTriggerId(id)) {
        this.openPopUp()
      }
    },

    openPopUp () {
      setTimeout(() => {
        this.$emit('change', true)
        this.$emit('opened', this.id)
        this.$root.$emit('popup-opened', this.id)
      }, 0)
    },

    withPopupTriggers (handler) {
      if (this.id) {
        Array.prototype.forEach.call(
          document.querySelectorAll(`a[href$="#${this.id}"]`),
          handler
        )
      }
    },

    onTriggerClick (e) {
      e.preventDefault()
      this.openPopUp()
    }
  }
}
</script>