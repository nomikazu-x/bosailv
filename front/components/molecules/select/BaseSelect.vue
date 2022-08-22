<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" :name="name" rules="required">
        <v-select
          v-model="valueModel"
          :label="label"
          outlined
          :value="value"
          :error-messages="errors"
          :items="items"
          :item-text="itemText"
          :item-value="itemValue"
          color="#117768"
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
  name: 'BaseSelect',

  components: {
    ValidationProvider
  },

  props: {
    items: {
      type: Array,
      default: () => []
    },
    name: {
      type: String,
      default: undefined
    },
    label: {
      type: String,
      default: undefined
    },
    value: {
      type: String,
      default: undefined
    },
    itemText: {
      type: String,
      default: undefined
    },
    itemValue: {
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
