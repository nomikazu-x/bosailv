<template>
  <v-btn
    color="amber darken-3"
    class="btn white--text"
    depressed
    :disabled="disabled"
    :large="large"
    :to="to"
    @click="onClick"
  >
    <slot />
  </v-btn>
</template>

<script>
export default {
  name: 'OrangeBtn',
  props: {
    disabled: {
      type: Boolean,
      default: false
    },
    large: {
      type: Boolean,
      default: false
    },
    to: {
      type: [String, Object],
      default: undefined
    }
  },
  methods: {
    onClick () {
      this.$emit('click')
    }
  }
}
</script>

<style lang="scss" scoped>
.btn {
  color: #747474;
}
</style>
