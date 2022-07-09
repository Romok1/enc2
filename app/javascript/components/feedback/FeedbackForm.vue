<template>
  <div class="feedback-form">
    <slot name="title">
      <h1 class="h2 h2--margin">
        {{ $t('form.feedback_title') }}
      </h1>
    </slot>

    <p v-if="showDescription">
      {{ $t('form.feedback_description') }}
    </p>

    <pop-up
      v-if="success"
      v-model="success"
      class="feedback-popup"
    >
      <template slot="pop-up">
        <div class="popup__inner">
          <success-feedback>
            <template v-slot:heading>
              {{ $t('buttons.sent') }}
            </template>
            <template v-slot:body>
              {{ $t('form.feedback_thankyou_message') }}
            </template>
            <template v-slot:cta>
              <a
                class="success-feedback__cta"
                href="#"
                @click.prevent="$root.$emit('pop-up:close')"
              >
                {{ $t('buttons.close') }}
              </a>
            </template>
          </success-feedback>
        </div>
      </template>
    </pop-up>
    <div
      v-else
      class="feedback-form"
    >
      <v-errors :errors="getErrors('base')" />
      <form
        class="form"
        @submit.prevent="onSubmit"
      >
        <v-field :error="hasErrors('full_name')">
          <label for="full_name">{{ $t('form.name') }}</label>
          <input
            v-model="form.full_name"
            v-focus
            :disabled="busy"
            required
            type="text"
          >
          <v-errors
            :errors="getErrors('full_name')"
            :prefix="$t('form.full_name') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('email')">
          <label for="email">{{ $t('form.email') }}</label>
          <input
            v-model="form.email"
            :disabled="busy"
            required
            type="email"
          >
          <v-errors
            :errors="getErrors('email')"
            :prefix="$t('form.email') + ' '"
          />
        </v-field>
        <v-field
          v-if="enquiryTypes.length"
          :error="hasErrors('enquiry_type')"
        >
          <label for="enquiry_type">{{ $t('form.enquiry_type') }}</label>
          <v-select-searchable
            v-model="form.enquiry_type"
            :config="{
              id: 'enquiry_type'
            }"
            :options="enquiryTypes"
            :disabled="busy"
          />
          <v-errors 
            :errors="getErrors('enquiry_type')"
            :prefix="$t('form.enquiry_type') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('message')">
          <label for="message">{{ $t('form.message') }}</label>
          <textarea
            v-model="form.message"
            :disabled="busy"
            required
            rows="7"
          />
          <v-errors
            :errors="getErrors('message')"
            :prefix="$t('form.message') + ' '"
          />
        </v-field>
        <v-field class="submit-button__container">
          <button
            class="submit-button"
            type="submit"
            :disabled="busy"
          >
            {{ $t('buttons.send') }}
          </button>
        </v-field>
      </form>
    </div>
  </div>
</template>
<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import PopUp from '~/common/PopUp'
import SuccessFeedback from '~/components/SuccessFeedback'
import VField from '~/components/form/VField'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: {
    PopUp,
    SuccessFeedback,
    VField,
    VSelectSearchable
  },

  mixins: [
    errorsMixin
  ],

  props: {
    enquiryTypes: {
      type: Array,
      default: () => []
    },

    showDescription: {
      type: Boolean,
      default: true
    }
  },

  data () {
    return {
      busy: false,
      form: {
        name: undefined,
        email: undefined,
        message: undefined
      },
      success: false
    }
  },

  methods: {
    onSubmit () {
      this.busy = true
      this.setErrors(undefined)
      this.$http({
        method: 'post',
        url: `/${this.$i18n.locale}/contact`,
        data: {
          ...this.form,
          current_url: window.location.href
        }
      })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => {
          this.busy = false
        })
    },

    onSuccess (response) {
      this.success = true
      this.$emit('success', response.data)
    },

    onError (e) {
      switch (e.response.status) {
      case UNPROCESSABLE_ENTITY:
        this.setErrors(e.response.data.errors)
        this.$emit('errors', e.response.data.errors)
        break
      default:
        this.setErrors({ base: [this.$t('errors.messages.unknown')] })
      }
    }
  }
}
</script>