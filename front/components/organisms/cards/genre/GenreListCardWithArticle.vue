<template>
  <v-row v-if="genres != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="困ったときは">
        <TheProcessing v-if="processing" />
        <div v-for="genre in genres" :key="genre.id">
          <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
            <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
          </v-img>
          <div v-for="article in genre.articles" :key="article.id">
            <ArticleListCardText
              :article="article"
            />
          </div>
          <v-btn
            large
            class="my-5"
            color="#ef5350"
            outlined
            block
            :to="{ name: 'genres-id___ja', params: { id: genre.id }}"
          >
            {{ genre.name }}をもっと見る
          </v-btn>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'GenresIndex',
  mixins: [Application],
  data () {
    return {
      genres: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.articles = null
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

<style lang="scss" scoped>
.genre-name {
  text-shadow: 1px 1px 0 #000, -1px 1px 0 #000, 1px -1px 0 #000, -1px -1px 0 #000;
}
</style>
