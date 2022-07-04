<template>
  <v-hover v-slot="{ hover }">
    <v-btn
      outlined
      color="#3c3c3c"
      class="thumb-up"
      x-large
      rounded
      :to="to"
      :style="{ 'background-color': hover ? '#FFFDE8' : 'white' }"
    >
      <slot />
    </v-btn>
  </v-hover>
</template>

<script>
export default {
  name: 'BaseBtn',
  props: {
    to: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
.thumb-up::before{
  background-color: #FFFDE8;
}
</style>
