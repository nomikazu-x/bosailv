<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" name="prefecture" rules="required">
        <v-select
          v-model="valueModel"
          label="出身都道府県"
          outlined
          :value="value"
          :error-messages="errors"
          :items="prefectures"
          item-text="name"
          item-value="id"
          @change="onChange"
        />
      </ValidationProvider>
    </v-col>
  </v-row>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'PrefecturesSelect',

  components: {
    ValidationProvider
  },

  props: {
    prefectures: {
      type: Array,
      default: () => []
    },
    value: {
      type: [Object, Number],
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
    onChange () {
      return this.$emit('change')
    }
  }
}
</script>
