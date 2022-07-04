<template>
  <ValidationProvider v-slot="{ errors }" name="email" rules="required|email|max:125">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      color="#3c3c3c"
      type="email"
      label="メールアドレス"
    />
  </ValidationProvider>
</template>

<script>
export default {
  name: 'EmailTextField',
  inheritAttrs: false,
  props: {
    value: {
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
