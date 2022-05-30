<template>
  <ValidationProvider v-slot="{ errors }" name="email" :rules="rule" :vid="vid">
    <v-text-field
      v-model="valueModel"
      v-bind="$attrs"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      type="email"
      label="メールアドレス"
      v-on="$listeners"
    />
  </ValidationProvider>
</template>

<script>
export default {
  inheritAttrs: false,
  props: {
    value: {
      type: String,
      default: undefined
    },
    vid: {
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
    },

    rule () {
      return 'required|email|max:125'
    }
  }
}
</script>
