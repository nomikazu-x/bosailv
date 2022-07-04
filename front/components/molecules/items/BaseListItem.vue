<template>
  <v-hover v-slot="{ hover }">
    <v-list-item
      :color="hover ? '#FFFDE8' : 'white' "
      class="thumb-up"
      :to="to"
      :dense="dense"
      :style="{ 'background-color': hover ? '#FFFDE8' : 'white' }"
    >
      <slot />
    </v-list-item>
  </v-hover>
</template>

<script>
export default {
  name: 'BaseListItem',
  props: {
    to: {
      type: [Object, String],
      default: null
    },
    dense: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
.thumb-up::before{
  background-color: #FFFDE8;
}
</style>
