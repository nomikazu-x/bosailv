<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title v-if="article">
        <span class="ml-1 font-weight-bold">
          {{ article.title }}
        </span>
        <span class="ml-1">
          ({{ $dateFormat(article.created_at, 'ja') }})
        </span>
      </v-card-title>
      <v-card-text v-if="article">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-if="article.content" class="mx-2 my-2" v-html="article.content" />
      </v-card-text>
      <v-divider />
      <v-card-actions>
        <ul class="my-2">
          <li><NuxtLink :to="`/articles/${$route.params.id}/edit`">編集</NuxtLink></li>
          <li @click="onArticleDelete(article.id)">削除</li>
        </ul>
        <FavoriteBtnGroup :article="article" @alert="alert = $event" @notice="notice = $event" />
      </v-card-actions>
    </v-card>
    <v-card>
      <v-card-title>コメント一覧</v-card-title>
      <v-divider class="my-4" />
      <article v-if="articleComments != null && articleComments.length === 0">
        <span class="ml-1">コメントはありません。</span>
        <v-divider class="my-4" />
      </article>
      <Comment v-for="articleComment in articleComments" :key="articleComment.id" :article-comment="articleComment" />
      <CommentArea :article="article" />
    </v-card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import FavoriteBtnGroup from '~/components/articles/FavoriteBtnGroup.vue'
import Comment from '~/components/articles/Comment.vue'
import CommentArea from '~/components/articles/CommentArea.vue'
import Application from '~/plugins/application.js'

export default {
  name: 'Articles',

  components: {
    FavoriteBtnGroup,
    Comment,
    CommentArea
  },

  mixins: [Application],

  data () {
    return {
      // article: null,
      // comments: null,
      content: ''
    }
  },
  computed: {
    ...mapGetters({
      article: 'articles/article',
      articleComments: 'articleComments/articleComments'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.$store.commit('articles/setArticle', response.data.article, { root: true })
        this.$store.commit('articleComments/setArticleComments', response.data.article.comments, { root: true })
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
    this.loading = false
  },

  methods: {
    async onArticleDelete (articleId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('articles/deleteArticle', articleId, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            return this.$router.push({ path: '/articles' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
