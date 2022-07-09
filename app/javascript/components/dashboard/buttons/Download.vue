<template>
  <button
    class="dashboard-button dashboard-button--download"
    :class="{ disabled: downloading }"
    @click="onClick"
  >
    <span class="dashboard-button__text">
      {{ $t('buttons.download') }}
    </span>

    <loading-spinner 
      v-if="downloading" 
      class="dashboard-button__loading-spinner"
    />

    <icon-download 
      v-else
      class="dashboard-button--icon"
    />
  </button>
</template>

<script>
import IconDownload from '~/icons/IconDownload'
import { getAlignmentOptionsQueryString } from '~/helpers/request-helpers'
import { poll } from '~/helpers/polling'
import { downloadPdf, getFetchDashboardPdfPath } from '~/helpers/request-helpers'
import LoadingSpinner from '~/common/LoadingSpinner'

export default {
  components: { IconDownload, LoadingSpinner },

  data () {
    return {
      downloading: false,
      jobId: ''
    }
  },

  computed: {
    alignmentOptionsSelections () {
      return this.$store.state.biodiversityGoals.dashboard.alignmentOptionSelections
    },

    biodiversityModule () {
      return this.$store.state.biodiversityGoals.dashboard.biodiversityModule
    },

    fetchUrl () {
      return `/${this.$i18n.locale}${getFetchDashboardPdfPath(this.biodiversityModule, this.jobId)}`
    },

    createUrl () {
      let alignmentOptionsQueryString = getAlignmentOptionsQueryString({
        selectedOptionIds: this.alignmentOptionsSelections,
        moduleName: this.biodiversityModule,
        paramsNestingKey: 'alignment_options'
      })

      if (alignmentOptionsQueryString) {
        alignmentOptionsQueryString = '&' + alignmentOptionsQueryString
      }

      return window.location.href.replace('?', '/create_pdf?') + alignmentOptionsQueryString
    }
  },

  methods: {
    onClick () {
      if (this.downloading) { return }

      this.downloading = true

      this.$http.post(this.createUrl)
        .then(res => {
          this.jobId = res.data.jobId

          poll({
            fn: () => this.$http.get(this.fetchUrl),
            validate: res => res.data.status !== 'Pending'
          }).then(this.handlePdfDownload)
        })
        .catch(this.onCreateError)
    },

    onCreateError (e) {
      console.error(e)
      this.reset()
    },

    handlePdfDownload (res) {
      const status = res.data.status

      if (status && status === 'Complete') {
        downloadPdf(`${this.fetchUrl}.pdf`)
      } else {
        console.error('PDF download failed')
      }

      this.reset()
    },

    reset () {
      this.downloading = false
      this.jobId = ''
    }
  }
}
</script>