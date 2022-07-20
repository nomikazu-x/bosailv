<template>
  <v-row v-if="genres != null">
    <v-col v-for="genre in genres" :key="genre.id" cols="6">
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
  name: 'GenreImageListCard',

  data () {
    return {
      genres: null
    }
  },

  computed: {
    toGenre () {
      return (genre) => {
        if (this.$route.params.username) {
          return { name: 'users-username-genres-id___ja', params: { username: this.$route.params.username, id: genre.id } }
        } else if (this.$route.path === '/admin/genres') {
          return { name: 'admin-genres-id-edit___ja', params: { id: genre.id } }
        } else {
          return { name: 'genres-id___ja', params: { id: genre.id } }
        }
      }
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.genres = null
        } else {
          this.genres = response.data.genres
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

    this.processing = false
  }
}
</script>
