<template>
  <ValidationProvider v-slot="{ errors }" name="keyword" rules="required">
    <v-text-field
      v-model="valueModel"
      label="キーワード検索"
      color="#3c3c3c"
      prepend-icon="mdi-magnify"
      :error-messages="errors"
      :value="value"
      dense
      outlined
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
