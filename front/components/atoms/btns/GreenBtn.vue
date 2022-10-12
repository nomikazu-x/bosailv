<template>
  <v-btn
    :id="id"
    color="#117768"
    class="btn"
    :disabled="disabled"
    :large="large"
    :small="small"
    :block="block"
    :outlined="outlined"
    :to="to"
    :href="href"
    :depressed="depressed"
    @click="onClick"
  >
    <slot />
  </v-btn>
</template>

<script>
export default {
  name: 'GreenBtn',
  props: {
    id: {
      type: String,
      default: null
    },
    disabled: {
      type: Boolean,
      default: false
    },
    large: {
      type: Boolean,
      default: false
    },
    small: {
      type: Boolean,
      default: false
    },
    block: {
      type: Boolean,
      default: false
    },
    outlined: {
      type: Boolean,
      default: false
    },
    to: {
      type: [String, Object],
      default: undefined
    },
    href: {
      type: String,
      default: undefined
    },
    depressed: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onClick () {
      return this.$emit('click')
    }
  }
}
</script>

<style lang="scss" scoped>
.btn {
  color: white;
}
</style>
