<template>
  <ValidationProvider v-slot="{ errors }" name="title" rules="required">
    <v-text-field
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      color="#3c3c3c"
      type="title"
      label="タイトル"
    />
  </ValidationProvider>
</template>

<script>
export default {
  name: 'ArticleTitleTextField',
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
