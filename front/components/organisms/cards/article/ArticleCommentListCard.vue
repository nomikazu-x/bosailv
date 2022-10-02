<template>
  <BaseTitleCard class="mt-3" title="コメント一覧">
    <div class="pa-5">
      <article v-if="articleComments != null && articleComments.length === 0">
        <v-card-text>この記事にコメントはありません。</v-card-text>
        <v-divider class="my-4" />
      </article>
      <ArticleCommentListCardText v-for="articleComment in articleComments" :key="articleComment.id" :article-comment="articleComment" />
      <ArticleCommentTextarea v-if="$auth.loggedIn" :article="article" />
    </div>
  </BaseTitleCard>
</template>

<script>
import { mapGetters } from 'vuex'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import ArticleCommentListCardText from '~/components/organisms/cardText/ArticleCommentListCardText.vue'
import ArticleCommentTextarea from '~/components/organisms/textarea/ArticleCommentTextarea.vue'

export default {
  name: 'ArticleCommentListCard',

  components: {
    BaseTitleCard,
    ArticleCommentListCardText,
    ArticleCommentTextarea
  },

  props: {
    article: {
      type: Object,
      default: null
    }
  },

  computed: {
    ...mapGetters({
      articleComments: 'articleComments/articleComments'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.commentsUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
        }
        this.$store.commit('articleComments/setArticleComments', response.data.comments, { root: true })
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/home' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/home' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
