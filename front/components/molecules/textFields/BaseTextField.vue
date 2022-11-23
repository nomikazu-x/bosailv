<template>
  <ValidationProvider v-slot="{ errors }" :name="name" :rules="rules">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      :prepend-icon="prependIcon"
      color="#117768"
      :label="label"
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
  name: 'BaseTextField',

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
      default: ''
    },
    name: {
      type: String,
      default: ''
    },
    rules: {
      type: [String, Object],
      default: 'required'
    },
    prependIcon: {
      type: String,
      default: ''
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
