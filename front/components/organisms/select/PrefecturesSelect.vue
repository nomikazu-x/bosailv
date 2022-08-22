<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" name="prefecture" rules="required">
        <v-select
          v-model="valueModel"
          label="都道府県"
          color="#117768"
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
    value: {
      type: [Object, Number],
      default: undefined
    }
  },

  data () {
    return {
      prefectures: []
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

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.prefecturesUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.prefectures = null
        } else {
          this.prefectures = response.data.prefectures
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

    this.processing = false
  },
  methods: {
    onChange () {
      return this.$emit('change')
    }
  }
}
</script>
