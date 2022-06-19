<template>
  <v-hover v-slot="{ hover }">
    <v-btn
      outlined
      color="#3c3c3c"
      class="thumb-up"
      x-large
      rounded
      :style="{ 'background-color': hover ? '#FFFDE8' : 'white' }"
    >
      <slot />
    </v-btn>
  </v-hover>
</template>

<style lang="scss" scoped>
.thumb-up::before{
  background-color: #FFFDE8;
}
</style>
