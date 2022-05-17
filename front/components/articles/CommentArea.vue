<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <ValidationProvider v-slot="{ errors }" name="content" rules="required">
          <v-textarea
            v-model="content"
            label="コメント"
            autocomplete="off"
            :error-messages="errors"
            @click="waiting = false"
          />
        </ValidationProvider>
        <v-btn id="comment_create_btn" color="primary" :disabled="invalid || processing || waiting" @click="onCommentCreate()">作成</v-btn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  props: {
    article: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      waiting: false,
      content: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onCommentCreate () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.commentCreateUrl.replace('_id', this.$route.params.id), {
        user_id: this.$auth.user.id,
        article_id: this.article.id,
        content: this.content
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('articleComments/addArticleComments', response.data.comment, { root: true })
            console.log(this.$store)
            this.content = ''
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
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
            if (error.response.data.errors != null) {
              this.$refs.observer.setErrors(error.response.data.errors)
              this.waiting = true
            }
          }
        })

      this.processing = false
    }
  }
}
</script>
