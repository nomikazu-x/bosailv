<template>
  <v-container :id="id" :class="{ 'no-gutters': noGutters }" :fluid="fluid" :tag="tag">
    <slot />
  </v-container>
</template>

<script>
export default {
  props: {
    id: {
      type: String,
      default: undefined
    },

    noGutters: {
      type: Boolean,
      default: false
    },

    fluid: {
      type: Boolean,
      default: false
    },

    tag: {
      type: String,
      default: 'div'
    }
  }
}
</script>

<style lang="scss" scoped>
.no-gutters {
  padding: {
    left: 0;
    right: 0;
  };
}
</style>
