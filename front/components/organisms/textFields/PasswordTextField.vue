<template>
  <ValidationProvider v-slot="{ errors }" name="password" rules="required|max:20|min:8">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      outlined
      counter
      inputmode="verbatim"
      hint="8文字以上の半角英数字のみ使用可能です"
      name="password"
      :label="label"
      dense
      color="#117768"
      :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
      :type="showPassword ? 'text' : 'password'"
      @click:append="showPassword = !showPassword"
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required, min, max } from 'vee-validate/dist/rules'

extend('required', required)
extend('max', max)
extend('min', min)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'PasswordTextField',

  components: {
    ValidationProvider
  },

  inheritAttrs: false,

  props: {
    value: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: 'パスワード [8文字以上]'
    }
  },

  data () {
    return {
      showPassword: false
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
