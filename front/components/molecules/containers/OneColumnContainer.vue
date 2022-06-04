<template>
  <BaseContainer :fluid="fluid" :no-gutters="noGutters">
    <v-row justify="center">
      <v-col :cols="cols" :sm="sm" :md="md" :lg="lg" :xl="xl">
        <slot />
      </v-col>
    </v-row>
  </BaseContainer>
</template>

<script>
export default {
  props: {
    fluid: {
      type: Boolean,
      default: false
    },

    noGutters: {
      type: Boolean,
      default: false
    },

    cols: {
      type: [Boolean, String, Number],
      default: 12
    },

    sm: {
      type: [Boolean, String, Number],
      default: false
    },

    md: {
      type: [Boolean, String, Number],
      default: 12
    },

    lg: {
      type: [Boolean, String, Number],
      default: false
    },

    xl: {
      type: [Boolean, String, Number],
      default: false
    }
  }
}
</script>
