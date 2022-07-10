<template>
  <v-hover v-slot="{ hover }">
    <v-card
      class="thumb-up"
      tile
      :color="hover ? '#FFFDE8' : 'white' "
      :to="to"
    >
      <slot />
    </v-card>
  </v-hover>
</template>

<script>
export default {
  name: 'BaseCard',
  props: {
    to: {
      type: Object,
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
