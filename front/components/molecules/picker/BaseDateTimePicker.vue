<template>
  <ValidationProvider v-slot="{ errors }" :name="name" :rules="rules">
    <v-card-text>
      {{ title }}
      <FlatPickr
        v-model="valueModel"
        :value="value"
        :config="flatOption"
        class="ml-2"
        placeholder="日時を選択"
      />
    </v-card-text>
    <p v-if="errors" class="mt-2 red--text">{{ errors[0] }}</p>
  </ValidationProvider>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'
import FlatPickr from 'vue-flatpickr-component'
import { Japanese } from 'flatpickr/dist/l10n/ja.js'
import 'flatpickr/dist/flatpickr.css'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'BaseDateTimeField',

  components: {
    ValidationProvider,
    FlatPickr
  },

  props: {
    value: {
      type: String,
      default: undefined
    },
    name: {
      type: String,
      default: ''
    },
    rules: {
      type: String,
      default: ''
    },
    title: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      flatOption: {
        locale: Japanese,
        enableTime: true,
        dateFormat: 'Y-m-d H:i',
        time_24hr: true
      }
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
