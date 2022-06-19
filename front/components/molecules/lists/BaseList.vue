<template>
  <v-hover v-slot="{ hover }">
    <v-list-item
      :color="hover ? '#FFFDE8' : 'white' "
      class="thumb-up"
      :to="to"
      :style="{ 'background-color': hover ? '#FFFDE8' : 'white' }"
    >
      <slot />
    </v-list-item>
  </v-hover>
</template>

<script>
export default {
  props: {
    to: {
      type: [Object, String],
      default: null
    }
  }
}
</script>

<style lang="scss" scoped>
.thumb-up::before{
  background-color: #FFFDE8;
}
</style>
