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
      @click="onClick"
    />
  </ValidationProvider>
</template>

<script>
export default {
  name: 'UserNameTextField',
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
  },
  methods: {
    onClick () {
      return this.$emit('click')
    }
  }
}
</script>
