<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" name="city" rules="required">
        <v-select
          v-model="valueModel"
          label="出身市町村"
          outlined
          :value="value"
          :error-messages="errors"
          :items="cities"
          item-text="name"
          item-value="city_code"
          @click="onClick"
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
  name: 'CitiesSelect',

  components: {
    ValidationProvider
  },

  props: {
    cities: {
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
    onClick () {
      return this.$emit('click')
    }
  }
}
</script>
