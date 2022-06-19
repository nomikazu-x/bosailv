<template>
  <BaseTitleCard class="mt-5" title="ジャンル一覧">
    <v-card>
      <GenreList
        :genres="genres"
        class="px-2"
      />
    </v-card>
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    genres: {
      type: Array,
      default: () => []
    }
  }
}
</script>
