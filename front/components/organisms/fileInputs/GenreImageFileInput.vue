<template>
  <v-row justify="center">
    <v-col v-if="getPreviewSrc != null" cols="12">
      <v-img
        :src="getPreviewSrc"
        max-height="300"
        class="pa-5 rounded-lg"
      />
    </v-col>
    <v-col cols="12">
      <ValidationProvider v-slot="{ errors }" name="image" rules="required|size_20MB:20480">
        <v-file-input
          v-model="valueModel"
          accept="image/jpeg,image/gif,image/png"
          label="画像を選択してください"
          prepend-icon="mdi-camera"
          show-size
          :error-messages="errors"
          @change="onInput"
        />
      </ValidationProvider>
    </v-col>
  </v-row>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { size, required } from 'vee-validate/dist/rules'

extend('size_20MB', size)
extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'ArticleThumbnailFileInput',

  components: {
    ValidationProvider
  },

  props: {
    oldSrc: {
      type: String,
      default: undefined
    },
    value: {
      type: [File, String, Object],
      default: undefined
    }
  },
  data () {
    return {
      newSrc: null
    }
  },
  computed: {
    valueModel: {
      get () {
        return this.value
      },
      set (newVal) {
        return this.$emit('input', newVal)
      }
    },
    getPreviewSrc () {
      return this.newSrc || this.oldSrc
    }
  },
  methods: {
    onInput (file) {
      if (!file) {
        this.newSrc = null
        return
      }
      this.fileToDataURL(file, () => {
        return this.newSrc
      })
    },
    fileToDataURL (file, onload) {
      const fr = new FileReader()
      fr.readAsDataURL(file)
      fr.onload = () => {
        this.newSrc = fr.result
        onload()
      }
    }
  }
}
</script>
