<template>
  <v-row justify="center">
    <v-col cols="12">
      <div v-if="user != null">
        <v-row>
          <v-col cols="12">
            <ArticleShowDetailCard
              :article="article"
              :user="user"
              :likers="likers"
            />
          </v-col>
          <v-col cols="12">
            <ArticleCommentListCard
              :user="user"
              :article-comments="articleComments"
              :article="article"
            />
          </v-col>
        </v-row>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'ArticlesId',

  data () {
    return {
      user: null,
      errors: null,
      content: ''
    }
  },

  computed: {
    ...mapGetters({
      article: 'articles/article',
      articleComments: 'articleComments/articleComments',
      likers: 'articles/likers'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.user = response.data.article.user
        this.$store.commit('articles/setArticle', response.data.article, { root: true })
        this.$store.commit('articleComments/setArticleComments', response.data.article.comments, { root: true })
        this.$store.commit('articles/setLikers', response.data.article.likers, { root: true })
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
