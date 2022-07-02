<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <GenreCard
            :genres="genres"
            :processing="processing"
          />
        </v-col>
      </v-row>
    </template>

    <template v-if="!loading" #right>
      <DefaultRightColumnTemplate />
    </template>
  </TwoColumnContainer>
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

    this.loading = false
    this.processing = false
  }
}
</script>
