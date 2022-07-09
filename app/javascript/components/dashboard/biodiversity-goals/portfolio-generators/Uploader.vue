<template>
  <div class="portfolio-uploader">
    <div
      :class="{
        'portfolio-generator-form--invalid': anyErrors
      }"
      class="portfolio-generator-form"
    >
      <div class="portfolio-generator-form__legend">
        <slot name="legend">
          {{ t.legend }}
        </slot>
      </div>

      <div class="portfolio-generator-form__data">
        <v-errors :errors="baseErrors.get('base')" />

        <v-field :error="formErrors.any()">
          <p class="portfolio-generator-form__heading">
            <slot name="heading">
              {{ t.heading }}
            </slot>
          </p>
          <v-upload
            v-model="file"
            :progress="progress"
            :validate="fileValidator"
          />
          <v-errors
            v-for="key in formErrors.keys()"
            :key="key"
            :errors="formErrors.index(key).get()"
          />
        </v-field>
        <a
          class="portfolio-generator-form__link"
          :href="templateDownloadPath"
          download
        >
          {{ t.download_csv_template }}
        </a>
      </div>
    </div>
    <Portal
      v-if="isTabActive"
      to="portfolio-generator-modal-footer"
    >
      <div class="portfolio-generator-modal__footer">
        <button
          class="portfolio-generator-modal__submit"
          @click.prevent="uploadFile"
        >
          <slot name="button">
            {{ t.button }}
          </slot>
        </button>
      </div>
    </Portal>
  </div>
</template>

<script>
import ErrorBag from '~/classes/ErrorBagV2'
import MultiErrorBag from '~/classes/MultiErrorBag'
import {
  BAD_REQUEST,
  UNPROCESSABLE_ENTITY,
} from '~/helpers/http-status-codes'

import VErrors from '~/components/form/VErrors'
import VField from '~/components/form/VField'
import VUpload from '~/components/form/VUpload'

export default {
  components: {
    VErrors,
    VField,
    VUpload
  },

  props: {
    endpoint: {
      type: String,
      required: true
    },

    redirect: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      baseErrors: new ErrorBag(),
      formErrors: new MultiErrorBag(),
      file: undefined,
      progress: 0
    }
  },

  computed: {
    anyErrors () {
      return this.baseErrors.any() || this.formErrors.any()
    },

    isTabActive () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.selectedTab === 'upload'
    },

    selectedSector () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.selectedSector
    },

    t () {
      const t = this.$t('biodiversity_goals.dashboard.portfolios_generator.uploader')

      return {
        ...t,
        legend: t.legend[this.selectedSector]
      }
    },

    templateDownloadPath () {
      return `/${this.$i18n.locale}/tools/biodiversity-goals/${this.selectedSector}-dashboard/csv-template`
    }
  },

  watch: {
    file () {
      this.baseErrors.reset()
      this.formErrors.reset()
    }
  },

  methods: {
    fileValidator (file) {
      return file.type === 'text/csv'
    },

    generateEndpoint (params) {
      return `${this.redirect}?${this.$qs(params)}`
    },

    setProgress (progress) {
      this.progress = progress
    },

    uploadFile () {
      if (this.file) {
        const formData = new FormData()

        formData.append('csv_upload', this.file)

        this.setProgress(50)
        this.baseErrors.reset()
        this.formErrors.reset()

        this.$http.post(this.endpoint, formData)
          .then(response => {
            this.setProgress(100)
            setTimeout(() => {
              window.open(this.generateEndpoint(response.data), '_self')
            }, 2000)
          })
          .catch(e => {
            console.error(e)

            this.setProgress(0)
            const { forms, ...baseErrors } = e.response.data.errors

            switch (e.response.status) {
            case BAD_REQUEST:
            case UNPROCESSABLE_ENTITY:
              this.baseErrors.set(baseErrors)
              this.formErrors.set(forms)
              break
            default:
              this.baseErrors.set({ base: [this.$t('biodiversity_goals.validation.manual_input.something_went_wrong')] })
            }
          })
      } else {
        this.baseErrors.set({ base: [this.$t('biodiversity_goals.validation.csv.not_found')] })
      }
    }
  }
}
</script>
