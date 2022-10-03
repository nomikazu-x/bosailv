<template>
  <v-card-text>
    <TheProcessing v-if="processing" />
    <v-row>
      <v-col cols="12">
        <v-avatar size="30"><v-img :src="articleComment.user.image_url.small" /></v-avatar>
        <span class="ml-1">{{ articleComment.user.name }}</span>
      </v-col>
      <v-col cols="12">
        <v-card-text>
          {{ articleComment.content }}
        </v-card-text>
        <div v-if="canAction" class="text-right">
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
  </v-card-text>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticleCommentListCardText',
  mixins: [Application],
  props: {
    articleComment: {
      type: Object,
      default: null
    }
  },

  computed: {
    canAction () {
      return (this.$auth.user && this.$auth.user.id) === this.articleComment.user.id
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
            this.$toasted.success(response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
