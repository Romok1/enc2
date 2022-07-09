<template>
  <div>
    <v-errors :errors="getErrors('base')" />
    <form
      class="form"
      @submit.prevent="onSubmit"
    >
      <v-field :error="hasErrors('unauthorized')">
        <label for="user_email">{{ $t('devise.labels.email') }}</label>
        <input
          v-model="form.email"
          v-focus
          :disabled="busy"
          type="email"
          autocomplete="email"
        >
        <v-errors :errors="getErrors('unauthorized')" />
      </v-field>
      <v-field :error="hasErrors('unauthorized')">
        <label for="user_password">{{ $t('devise.labels.password') }}</label>
        <v-password-input
          v-model="form.password"
          :disabled="busy"
          autocomplete="off"
        />
      </v-field>

      <v-field class="mt-0 flex-md flex-h-between">
        <v-field class="mt-1">
          <v-checkbox
            v-model="form.remember_me"
            :disabled="busy"
            :label="$t('devise.labels.remember_me')"
          />
        </v-field>
        <v-field class="mt-1">
          <a :href="`/${$i18n.locale}/users/password/new`">
            {{ $t('devise.ctas.no_password') }}
          </a>
        </v-field>
      </v-field>

      <v-field>
        <button
          class="button button--green button--medium mt-2"
          type="submit"
          :disabled="busy"
        >
          {{ $t('devise.ctas.sign_in') }}
        </button>
      </v-field>
    </form>
  </div>
</template>
<script>
import {
  UNAUTHORIZED,
  // UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import VCheckbox from '~/components/form/VCheckbox.vue'
import VField from '~/components/form/VField.vue'
import VPasswordInput from '~/components/form/VPasswordInput.vue'

export default {
  components: {
    VCheckbox,
    VField,
    VPasswordInput,
  },
  mixins: [
    errorsMixin
  ],
  data () {
    return {
      busy: false,
      form: {
        email: undefined,
        password: undefined,
        remember_me: false,
      }
    }
  },
  methods: {
    onSubmit () {
      this.busy = true
      this.setErrors(undefined)
      this.$http.post(`/${this.$i18n.locale}/users/sign_in`, { user: this.form })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => {
          this.busy = false
        })
    },
    onSuccess () {
      const redirectTo = `/${this.$i18n.locale}/tools`

      this.$emit('success', { redirectTo })
      window.open(redirectTo, '_self')
    },
    onError (e) {
      switch (e.response.status) {
      case UNAUTHORIZED:
        this.setErrors({ unauthorized: [e.response.data.error] })
        break
      default:
        this.setErrors({ base: [this.$t('errors.messages.unknown')] })
      }
      this.$emit('errors', {})
    },
  }
}
</script>
