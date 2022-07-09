<template>
  <div class="user-form">
    <div v-if="show">
      <slot name="header" />
      <v-errors :errors="getErrors('base')" />
      <form
        class="form"
        @submit.prevent="onSubmit"
      >
        <v-field :error="hasErrors('name')">
          <label for="user_name">{{ $t('devise.labels.name') }}</label>
          <input
            v-model="form.name"
            v-focus
            :disabled="busy"
            type="text"
            @input="clearErrors('name')"
          >
          <v-errors
            :errors="getErrors('name')"
            :prefix="$t('devise.labels.name') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('organisation')">
          <label for="user_organisation">{{ $t('devise.labels.organisation') }}</label>
          <input
            v-model="form.organisation"
            :disabled="busy"
            type="text"
            @input="clearErrors('organisation')"
          >
          <v-errors
            :errors="getErrors('organisation')"
            :prefix="$t('devise.labels.organisation') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('organisation_type')">
          <label for="user_organisation_type">{{ $t('devise.labels.organisation_type') }}</label>
          <v-select-searchable
            v-model="form.organisation_type_id"
            :config="{
              id: 'user_organisation_type'
            }"
            :options="organisationTypes"
            :disabled="busy"
            @update:selected-option="clearErrors('organisation_type')"
          />
          <v-errors
            :errors="getErrors('organisation_type')"
            :prefix="$t('devise.labels.organisation_type') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('country')">
          <label for="user_country">{{ $t('devise.labels.country') }}</label>
          <v-select-searchable
            v-model="form.country_id"
            :config="{
              id: 'user_country',
              hasSearch: true
            }"
            :options="countries"
            :disabled="busy"
            @update:selected-option="clearErrors('country')"
          />
          <v-errors
            :errors="getErrors('country')"
            :prefix="$t('devise.labels.country') + ' '"
          />
        </v-field>
        <v-field :error="hasErrors('email')">
          <label for="user_email">{{ $t('devise.labels.email') }}</label>
          <input
            v-model="form.email"
            :disabled="busy"
            type="email"
            @input="clearErrors('email')"
          >
          <v-errors
            :errors="getErrors('email')"
            :prefix="$t('devise.labels.email') + ' '"
          />
        </v-field>
        <i
          v-if="user && user.unconfirmed_email"
          class="mb-3"
        >
          {{
            $t('devise.labels.unconfirmed_email_notice',
               { unconfirmed_email: user.unconfirmed_email }
            )
          }}
        </i>
        <div v-if="user">
          <v-field :error="hasErrors('current_password')">
            <label for="user_current_password">{{ $t('devise.labels.current_password') }}</label>
            <v-password-input
              v-model="form.current_password"
              :disabled="busy"
              autocomplete="current-password"
              @input="clearErrors('current_password')"
            />
            <v-errors
              :errors="getErrors('current_password')"
              :prefix="$t('devise.labels.current_password') + ' '"
            />
          </v-field>
        </div>
        <button
          v-if="user"
          class="user-form__change-password-button"
          type="button"
          @click.prevent="toggleShowChangePasswordInputs"
        >
          {{ $t('devise.ctas.change_password') }}
        </button>
        <div v-if="!user || showChangePasswordInputs">
          <v-field :error="hasErrors('password')">
            <label for="user_password">
              {{ $t('devise.labels.' + (user ? 'new_' : '') + 'password') }}
            </label>
            <v-password-input
              id="new-password"
              v-model="form.password"
              :disabled="busy"
              autocomplete="new-password"
              @input="clearErrors('password')"
            />
            <v-errors
              :errors="getErrors('password')"
              :prefix="$t('devise.labels.password') + ' '"
            />
          </v-field>
          <v-field>
            <label for="user_password_confirmation">{{ $t('devise.labels.' + (user ? 'new_' : '') + 'password_confirmation') }}</label>
            <v-password-input
              v-model="form.password_confirmation"
              :disabled="busy"
              autocomplete="new-password"
              @input="clearErrors('password_confirmation')"
            />
            <v-errors
              :errors="getErrors('password_confirmation')"
              :prefix="$t('devise.labels.password_confirmation') + ' '"
            />
          </v-field>
        </div>
        <v-field
          v-if="!user"
          :error="hasErrors('terms')"
        >
          <v-checkbox
            v-model="form.terms"
            :disabled="busy"
            @change="clearErrors('terms')"
          >
            <span
              v-html="$t(
                'devise.ctas.acknowledge_terms_and_conditions',
                { url: $url('/legal') }
              )"
            />
          </v-checkbox>
          <v-errors
            :errors="getErrors('terms')"
            :prefix="$t('devise.labels.terms') + ' '"
          />
        </v-field>
        <v-field
          :error="hasErrors('agreed_to_contact_for_new_functionality_updates')"
        >
          <v-checkbox
            v-model="form.agreed_to_contact_for_new_functionality_updates"
            :disabled="busy"
            @change="clearErrors('agreed_to_contact_for_new_functionality_updates')"
          >
            <span
              v-html="$t(
                'devise.ctas.agree_to_be_contacted_for_new_functionality_updates',
                { url: $url('/legal') }
              )"
            />
          </v-checkbox>
          <v-errors
            :errors="getErrors('agreed_to_contact_for_new_functionality_updates')"
            :prefix="$t('devise.labels.agreed_to_contact_for_new_functionality_updates') + ' '"
          />
        </v-field>
        <v-field class="submit-button__container">
          <button
            class="submit-button"
            type="submit"
            :disabled="busy"
          >
            {{ $t('devise.ctas.' + (user ? 'update' : 'sign_up')) }}
          </button>
        </v-field>
      </form>
      <slot name="footer" />
    </div>
    <loading-spinner v-else />
  </div>
</template>
<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import LoadingSpinner from '~/common/LoadingSpinner'
import VCheckbox from '~/components/form/VCheckbox'
import VField from '~/components/form/VField'
import VPasswordInput from '~/components/form/VPasswordInput'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: {
    LoadingSpinner,
    VCheckbox,
    VField,
    VPasswordInput,
    VSelectSearchable,
  },

  mixins: [
    errorsMixin
  ],

  props: {
    redirectTo: {
      type: String,
      default: undefined
    }
  },

  data () {
    return {
      show: false,
      showChangePasswordInputs: false,
      busy: false,
      form: {
        agreed_to_contact_for_new_functionality_updates: false,
        country_id: undefined,
        email: undefined,
        name: undefined,
        organisation: undefined,
        organisation_type_id: undefined,
        terms: false
      },
      countries: undefined,
      organisationTypes: undefined
    }
  },

  computed: {
    user: {
      get: function () {
        return this.$store.state.user
      },
      set: function (user) {
        this.$store.commit('updateUser', user)
      }
    }
  },

  created () {
    Promise.all([
      this.$http.get(`/${this.$i18n.locale}/organisation_types`),
      this.$http.get(`/${this.$i18n.locale}/countries`)
    ])
      .then(([organisationTypes, countries]) => {
        this.organisationTypes = organisationTypes.data
        this.countries = countries.data

        this.resetForm()

        this.show = true
      })
      .catch(() => this.setErrors({ base: [this.$t('errors.messages.unknown')] }))
      .finally(() => (this.$emit('ready')))
  },

  methods: {
    onSubmit () {
      this.busy = true
      this.setErrors(undefined)
      this.$http({
        method: this.user ? 'patch' : 'post',
        url: `/${this.$i18n.locale}/users`,
        data: { user: this.form }
      })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => {
          this.busy = false
          this.$emit('ready')
        })
    },

    async onSuccess () {
      if (this.redirectTo) {
        window.open(this.redirectTo, '_self')
      } else {
        if (this.user) {
          this.busy = true

          try {
            const response = await this.$http.get(`/${this.$i18n.locale}/my_identity`)

            this.user = response.data
          } catch (e) {
            console.error(e)
          }

          this.busy = false
        }

        this.resetForm()

        this.$emit('success')
      }
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

    resetForm () {
      if (this.user) {
        const {
          name,
          organisation,
          organisation_type_id,
          country_id,
          email,
          agreed_to_contact_for_new_functionality_updates
        } = this.user

        this.form = {
          ...this.form,
          name,
          organisation,
          organisation_type_id,
          country_id,
          email,
          agreed_to_contact_for_new_functionality_updates
        }
      }

      this.form.password = undefined
      this.form.password_confirmation = undefined
      this.form.current_password = undefined
    },

    toggleShowChangePasswordInputs () {
      this.showChangePasswordInputs = !this.showChangePasswordInputs
    }
  }
}
</script>
