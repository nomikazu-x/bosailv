<template>
  <div>
    <article>
      <Processing v-if="processing" />
      <!-- eslint-disable-next-line vue/no-v-html -->
      <div class="mx-2 my-2" v-html="comment.content" />
      <div>
        <span class="ml-1">
          ({{ $dateFormat(comment.created_at, 'ja') }})
        </span>
      </div>
      <v-btn icon>
        <v-icon size="20" @click="onCommentDelete()">
          mdi-trash-can-outline
        </v-icon>
      </v-btn>
      <v-divider class="my-4" />
    </article>
  </div>
</template>

<script>
export default {
  props: {
    comment: {
      type: Object,
      default: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onCommentDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.commentDeleteUrl.replace('_id', this.comment.id), {
        user_id: this.$auth.user.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
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
