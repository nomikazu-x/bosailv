<template>
  <v-row justify="center">
    <v-col cols="12">
      <v-img
        :src="getPreviewSrc"
        max-height="300"
        class="pa-5 rounded-lg"
      />
    </v-col>
    <v-col cols="12">
      <ValidationProvider v-slot="{ errors }" name="thumbnail" rules="size_20MB:20000">
        <v-file-input
          v-model="valueModel"
          :value="value"
          accept="image/jpeg,image/gif,image/png"
          label="サムネイルを選択してください"
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
export default {
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
