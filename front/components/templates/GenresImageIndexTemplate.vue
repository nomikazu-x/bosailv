<template>
  <OneColumnContainer>
    <v-row justify="center">
      <v-col cols="12" sm="10" md="10">
        <v-card class="mt-5">
          <v-row>
            <v-col cols="12">
              <v-card-title>ジャンル一覧</v-card-title>
              <GenreList
                :genres="genres"
                class="px-2"
              />
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </OneColumnContainer>
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
