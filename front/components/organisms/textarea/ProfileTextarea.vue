<template>
  <ValidationProvider v-slot="{ errors }" name="name" rules="required">
    <v-textarea
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      label="自己紹介"
      auto-grow
      counter
      color="#3c3c3c"
      name="profile"
      maxlength="255"
      @click="onClick"
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'ProfileTextarea',

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
  },

  methods: {
    onClick () {
      return this.$emit('click')
    }
  }
}
</script>
