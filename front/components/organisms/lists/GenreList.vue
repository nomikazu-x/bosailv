<template>
  <v-row>
    <v-col v-for="genre in genres" :key="genre.id" cols="4" sm="6">
      <v-card :to="toGenre(genre)">
        <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.5)">
          <v-card-title class="mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
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
  },
  computed: {
    toGenre () {
      return (genre) => {
        if (this.$route.params.username) {
          return { name: 'users-username-genres-id___ja', params: { username: this.$route.params.username, id: genre.id } }
        }
        return { name: 'genres-id___ja', params: { id: genre.id } }
      }
    }
  }
}
</script>
