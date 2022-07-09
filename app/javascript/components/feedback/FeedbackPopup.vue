<template>
  <pop-up
    id="feedback-popup"
    v-model="show"
    class="feedback-popup"
    :class="'feedback-popup--' + popupClass"
  >
    <template slot="trigger--open">
      <div class="form__pop-up-trigger feedback-svg" />
    </template>

    <template slot="pop-up">
      <div class="popup__inner">
        <feedback-form v-bind="{ enquiryTypes }" />
      </div>
    </template>
  </pop-up>
</template>
<script>
import FeedbackForm from '~/components/feedback/FeedbackForm'
import PopUp from '~/common/PopUp'

export default {
  components: {
    PopUp,
    FeedbackForm
  },

  props: {
    enquiryTypes: {
      type: Array,
      default: () => []
    },
    popupClass: {
      type: String,
      required: true,
      validator: popupClass => ['fixed', 'nav'].indexOf(popupClass) !== -1
    }
  },

  data () {
    return {
      show: false
    }
  }
}
</script>