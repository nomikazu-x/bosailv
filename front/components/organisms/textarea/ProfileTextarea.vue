<template>
  <ValidationProvider v-slot="{ errors }" name="name" rules="required">
    <v-textarea
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      dense
      outlined
      label="自己紹介"
      auto-grow
      counter
      color="#3c3c3c"
      name="profile"
      maxlength="255"
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
