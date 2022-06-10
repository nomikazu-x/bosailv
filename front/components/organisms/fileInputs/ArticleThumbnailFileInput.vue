<template>
  <v-row justify="center">
    <v-col cols="12">
      <v-sheet v-if="url">
        <v-img :src="url" max-width="600" max-height="400" class="ml-5 mt-2 rounded-lg" />
      </v-sheet>
      <v-sheet v-if="!url">
        <v-img :src="require('~/assets/images/xlarge_noimage.jpeg')" max-width="600" max-height="400" class="ml-5 mt-2 rounded-lg" />
      </v-sheet>
      <ValidationProvider v-slot="{ errors }" name="valueModel" rules="size_20MB:20000">
        <v-file-input
          v-model="valueModel"
          accept="image/jpeg,image/gif,image/png"
          label="画像ファイル"
          prepend-icon="mdi-camera"
          show-size
          :error-messages="errors"
        />
      </ValidationProvider>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    value: {
      type: File,
      default: undefined
    },
    url: {
      type: String,
      default: undefined
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
    }
  }
}
</script>
