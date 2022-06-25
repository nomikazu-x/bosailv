<template>
  <ValidationProvider v-slot="{ errors }" name="name" rules="required">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      color="#3c3c3c"
      type="name"
      label="氏名"
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
