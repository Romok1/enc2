<template>
  <div>
    <password-success v-if="showSuccess" />

    <template v-else>
      <icon-lock class="devise__icon--lock" />

      <h2>{{ $t('devise.ctas.change_your_password') }}</h2>

      <p class="devise__description">
        {{ $t('devise.ctas.change_your_password_description') }}
      </p>
      
      <v-errors :errors="getErrors('base')" />
      <form
        class="form"
        @submit.prevent="onSubmit"
      >
        <v-field :error="hasErrors('password')">
          <label for="user_password">
            {{ $t('devise.labels.new_password') }}
          </label>
          <v-password-input
            v-model="form.password"
            :disabled="busy"
            autocomplete="new-password"
          />
          <v-errors
            :errors="getErrors('password')"
            :prefix="$t('devise.labels.password') + ' '"
          />
        </v-field>

        <v-field>
          <label for="user_password_confirmation">{{ $t('devise.labels.new_password_confirmation') }}</label>
          <v-password-input
            v-model="form.password_confirmation"
            :disabled="busy"
            autocomplete="new-password"
          />
          <v-errors
            :errors="getErrors('password_confirmation')"
            :prefix="$t('devise.labels.password_confirmation') + ' '"
          />
        </v-field>

        <v-field>
          <button
            class="button button--green button--medium"
            type="submit"
          >
            {{ $t('devise.ctas.update') }}
          </button>
        </v-field>
      </form>
    </template>
  </div>
</template>
<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import IconLock from '~/icons/IconLock'
import PasswordSuccess from '~/components/authentication/PasswordSuccess'
import VField from '~/components/form/VField.vue'
import VPasswordInput from '~/components/form/VPasswordInput'

export default {
  components: {
    IconLock,
    PasswordSuccess,
    VField,
    VPasswordInput
  },

  mixins: [
    errorsMixin
  ],

  props: {
    resetPasswordToken: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      busy: false,
      form: {
        password: undefined,
        password_confirmation: undefined,
        reset_password_token: this.resetPasswordToken
      },
      showSuccess: false
    }
  },

  methods: {
    onSubmit () {
      this.busy = true
      this.setErrors(undefined)
      this.$http.patch(`/${this.$i18n.locale}/users/password`, { user: this.form })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => {
          this.busy = false
        })
    },
    onSuccess () {
      this.showSuccess = true
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
    },
  }
}
</script>