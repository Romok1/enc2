<template>
  <pop-up
    id="account-management-popup"
    v-model="show"
    class="account-management-popup"
    @closed="setUpdated(false)"
  >
    <template slot="pop-up">
      <success-feedback v-if="updated">
        <template v-slot:heading>
          {{ $t('feedback.thank_you') }}
        </template>
        <template v-slot:body>
          {{ $t('devise.registrations.updated') }}
        </template>
        <template v-slot:cta>
          <a
            class="success-feedback__cta"
            href="#"
            @click.prevent="setUpdated(false)"
          >
            {{ $t('labels.close') }}
          </a>
        </template>
      </success-feedback>
      <div
        v-else
        class="p-5"
      >
        <user-form
          v-bind="{ user }"
          @success="onSuccess"
        >
          <template v-slot:header>
            <h1>{{ $t('auth.account_details') }}</h1>
          </template>
        </user-form>
      </div>
    </template>
  </pop-up>
</template>
<script>
import PopUp from '~/common/PopUp'
import SuccessFeedback from '~/components/SuccessFeedback'
import UserForm from '~/components/authentication/UserForm'

export default {
  components: {
    PopUp,
    SuccessFeedback,
    UserForm,
  },

  props: {
    user: {
      default: undefined,
      type: Object
    }
  },

  data () {
    return {
      show: false,
      updated: false
    }
  },

  methods: {
    onSuccess () {
      this.setUpdated(true)
    },

    setUpdated(updated) {
      this.updated = updated === true
    }
  }
}
</script>