<template>
  <ValidationProvider v-slot="{ errors }" name="keyword" rules="required">
    <v-text-field
      v-model="valueModel"
      label="キーワード検索"
      color="#3c3c3c"
      prepend-icon="mdi-magnify"
      :error-messages="errors"
      :value="value"
      dense
      outlined
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'ArticleSearchTextField',

  components: {
    ValidationProvider
  },

  inheritAttrs: false,

  props: {
    value: {
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
