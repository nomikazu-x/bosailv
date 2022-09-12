<template>
  <v-row v-if="genres != null" no-gutters>
    <v-col v-for="genre in genres" :key="genre.id" cols="4">
      <BaseCard :to="toGenre(genre)" class="ma-1">
        <div class="text-center py-5">
          <v-icon color="#117768" size="50">{{ genre.icon }}</v-icon>
          <div class="font-weight-bold mt-1 justify-center">{{ genre.name }}</div>
        </div>
      </BaseCard>
    </v-col>
  </v-row>
</template>

<script>
import BaseCard from '~/components/molecules/cards/BaseCard.vue'

export default {
  name: 'GenreImageListCard',

  components: {
    BaseCard
  },

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
