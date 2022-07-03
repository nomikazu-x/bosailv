<template>
  <div v-if="alert || notice">
    <v-alert
      v-if="alert"
      type="error"
      border="top"
      colored-border
      elevation="2"
    >
      {{ alert }}
    </v-alert>
    <v-alert
      v-if="notice"
      border="top"
      colored-border
      type="info"
      elevation="2"
    >
      {{ notice }}
    </v-alert>
  </div>
</template>
<script>
export default {
  name: 'Message',
  props: {
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  }
}
</script>
