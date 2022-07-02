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
      <TopSlide v-if="!loading" :articles="articles" />
    </template>

    <template v-if="!loading" #left>
      <div>
        <TopTransitionCard />
        <ArticleCard
          :info="info"
          :articles="articles"
          :processing="processing"
          :loading="loading"
          :alert="alert"
          :notice="notice"
          @pagination="onPagination"
        />
        <BaseTitleCard class="mt-5" title="ジャンル一覧">
          <v-card>
            <GenreImageCard
              :genres="genres"
              class="px-2"
            />
          </v-card>
        </BaseTitleCard>
      </div>
    </template>

    <template v-if="!loading" #right>
      <DefaultRightColumnTemplate />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Index',
  mixins: [Application],
  data () {
    return {
      genres: null,
      page: 1,
      info: null,
      articles: null
    }
  },
  async created () {
    await this.onPagination(this.page)

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

    this.loading = false
    this.processing = false
  },

  methods: {
    async onPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page }
      })
        .then((response) => {
          if (response.data == null || response.data.article == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.info == null) {
            return this.$router.push({ path: '/' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
