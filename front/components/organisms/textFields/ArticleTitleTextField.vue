<template>
  <ValidationProvider v-slot="{ errors }" name="title" rules="required">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      type="title"
      label="タイトル"
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
