<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" name="disaster_type">
        <v-select
          v-model="valueModel"
          label="災害種別"
          color="#117768"
          outlined
          :value="value"
          :error-messages="errors"
          :items="disasterTypes"
          item-text="name"
          item-value="value"
        />
      </ValidationProvider>
    </v-col>
  </v-row>
</template>

<script>
import { ValidationProvider, configure, localize } from 'vee-validate'

configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'DisasterTypeSelect',

  components: {
    ValidationProvider
  },

  props: {
    value: {
      type: [Object, String],
      default: undefined
    }
  },

  data () {
    return {
      disasterTypes: [
        { name: '洪水', value: 'flood' },
        { name: '土砂', value: 'landslide' },
        { name: '高潮', value: 'storm_surge' },
        { name: '地震', value: 'earthquake' },
        { name: '津波', value: 'tsunami' },
        { name: '火事', value: 'fire' },
        { name: '内水氾濫', value: 'inland_flood' },
        { name: '火山', value: 'volcano' }
      ]
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
