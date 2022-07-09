<template>
  <div>
    <v-errors :errors="getErrors('base')" />
    <form
      class="form"
      @submit.prevent="onSubmit"
    >
      <v-field :error="hasErrors('email')">
        <label for="user_email">{{ $t('devise.labels.email') }}</label>
        <input
          v-model="form.email"
          v-focus
          :disabled="busy"
          type="email"
          autocomplete="email"
        >
        <v-errors
          :errors="getErrors('email')"
          :prefix="$t('devise.labels.email') + ' '"
        />
      </v-field>

      <v-field>
        <button
          class="button button--green button--medium"
          type="submit"
        >
          {{ $t('devise.ctas.send_password_reset_instructions') }}
        </button>
      </v-field>
    </form>
  </div>
</template>
<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import VField from '~/components/form/VField.vue'

export default {
  components: {
    VField,
  },
  mixins: [
    errorsMixin
  ],
  data () {
    return {
      busy: false,
      form: {
        email: undefined,
      }
    }
  },
  computed: {
    unfilled () {
      return !this.form.email
    }
  },
  methods: {
    onSubmit () {
      this.busy = true
      this.setErrors(undefined)
      this.$http.post(`/${this.$i18n.locale}/users/password`, { user: this.form })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => {
          this.busy = false
        })
    },
    onSuccess () {
      this.form.email = undefined
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