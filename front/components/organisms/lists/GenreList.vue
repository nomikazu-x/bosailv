<template>
  <v-row>
    <v-col v-for="genre in genres" :key="genre.id" cols="6">
      <v-card :to="{ name: 'users-username-genre-id___ja', params: { id: genre.id }}" class="my-3">
        <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.5)">
          <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
        </v-img>
      </v-card>
    </v-col>
  </v-row>
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

<style lang="scss" scoped>
// .genre-name {
//   text-shadow: 1px 1px 0 #000, -1px 1px 0 #000, 1px -1px 0 #000, -1px -1px 0 #000;
// }
</style>
