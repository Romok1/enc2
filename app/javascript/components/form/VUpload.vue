<template>
  <div
    class="v-upload"
    :class="{ 'v-upload--dragged-over': isDraggedOver }"
    @drop.prevent="onDrop"
    @drag.prevent="onDragover"
    @dragenter.prevent="onDragover"
    @dragleave.prevent="onDragleave"
    @dragover.prevent="onDragover"
  >
    <div class="v-upload__body">
      <div v-if="!file">
        <p class="v-upload__heading">
          {{ $t('form.drag_and_drop') }}
        </p>
      </div>
      <div v-else>
        <button
          class="v-upload__delete"
          @click="setFile(undefined)"
        >
          {{ $t('common.delete') }}
        </button>
        <p class="v-upload__heading">
          <strong>{{ file.name }}</strong>
          <span>({{ filesize(file.size, { bits: true }) }})</span>
        </p>
        <div
          v-if="progress"
          class="v-upload__progress"
        >
          <div
            class="v-upload__progress-bar"
            role="progressbar"
            :aria-valuenow="progress"
            aria-valuemin="0"
            aria-valuemax="100"
            :style="{ width: progress + '%' }"
          />
        </div>
        <p
          v-if="progress"
          class="v-upload__heading"
        >
          {{ progress }}%
        </p>
      </div>
      <label
        class="v-upload__label"
        for="csv_upload"
      >
        {{ $t('form.choose_file') }}
      </label>

      <input
        id="csv_upload"
        type="file"
        name="filename"
        class="v-upload__input"
        @change="onChange"
      >
    </div>
  </div>
</template>

<script>
import filesize from 'filesize'
import { delay } from 'lodash'

export default {
  model: {
    event: 'change',
    prop: 'file'
  },

  props: {
    errors: {
      type: Object,
      default: undefined
    },

    file: {
      type: File,
      default: undefined
    },

    progress: {
      type: Number,
      default: 0,
      validator: progress => progress >= 0 && progress <= 100
    },

    validate: {
      type: Function,
      default: file => {
        return Boolean(file)
      }
    },
  },

  data () {
    return {
      dragTimeoutId: undefined,
      isDraggedOver: false,
    }
  },

  methods: {
    filesize,

    setDraggedOver (isDraggedOver) {
      this.isDraggedOver = isDraggedOver === true
    },

    setFile (file) {
      if (file) {
        if (this.validate(file)) {
          this.$emit('change', file)
        } else {
          // TODO: Change to new translation
          this.errors.set({ base: [this.$t('form.error_msg')] })
        }
      }  else {
        this.$emit('change', undefined)
      }
    },

    onChange (e) {
      const file = e.target.files.item(0) || this.file

      this.setFile(file)
    },

    onDragover() {
      this.setDraggedOver(true)
      clearTimeout(this.dragTimeoutId)
    },

    onDragleave() {
      this.dragTimeoutId = delay(() => {
        this.setDraggedOver(false)
      }, 50)
    },

    onDrop (e) {
      this.setDraggedOver(false)
      const file = e.dataTransfer.files.item(0)

      this.setFile(file)
    }
  }
}
</script>
