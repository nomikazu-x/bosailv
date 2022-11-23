<template>
  <ValidationProvider v-slot="{ errors }" :name="name" :rules="rules">
    <v-textarea
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      :label="label"
      auto-grow
      counter
      color="#117768"
      :name="name"
      maxlength="255"
      @click="onClick"
      @change="onChange"
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required, max } from 'vee-validate/dist/rules'

extend('required', required)
extend('max', max)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'BaseTextarea',

  components: {
    ValidationProvider
  },

  inheritAttrs: false,

  props: {
    value: {
      type: String,
      default: undefined
    },
    label: {
      type: String,
      default: undefined
    },
    name: {
      type: String,
      default: undefined
    },
    rules: {
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
    },

    onChange () {
      return this.$emit('change')
    }
  }
}
</script>
