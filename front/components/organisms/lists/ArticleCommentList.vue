<template>
  <div>
    <article>
      <Processing v-if="processing" />
      <v-row>
        <v-col cols="12">
          <v-avatar size="30"><v-img :src="articleComment.user.image_url.small" /></v-avatar>
          <span class="ml-1">{{ articleComment.user.name }}</span>
        </v-col>
        <v-col cols="12">
          <!-- eslint-disable-next-line vue/no-v-html -->
          <v-card-text v-html="articleComment.content" />
          <div class="text-right">
            <v-btn icon>
              <v-icon size="20" @click="onCommentDelete(articleComment.id)">
                mdi-trash-can-outline
              </v-icon>
            </v-btn>
          </div>
          <div class="text-right">
            ({{ $dateFormat(articleComment.created_at, 'ja') }})
          </div>
          <v-divider class="my-4" />
        </v-col>
      </v-row>
    </article>
  </div>
</template>

<script>
export default {
  props: {
    articleComment: {
      type: Object,
      default: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onCommentDelete (articleCommentId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.commentDeleteUrl.replace('_id', articleCommentId), {
        user_id: this.$auth.user.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('articleComments/deleteArticleComment', articleCommentId, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
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
