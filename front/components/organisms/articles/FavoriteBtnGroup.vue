<template>
  <span>
    <v-btn v-if="isFavorited" x-large outlined icon color="red" @click="onUnFavorite">
      <v-icon size="30" color="red">mdi-heart</v-icon>
    </v-btn>
    <v-btn v-else x-large outlined icon @click="onFavorite">
      <v-icon size="30" color="red">mdi-heart-outline</v-icon>
    </v-btn>
    <span><NuxtLink :to="`/articles/${$route.params.id}/likers`" class="text-decoration-none">{{ article.likers.length }}</NuxtLink></span>
  </span>
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
      isFavorited: this.article.is_favorited
    }
  },

  methods: {
    async onFavorite () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.favoriteCreateUrl.replace('_id', this.$route.params.id), {
        user_id: this.$auth.user.id,
        article_id: this.article.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.isFavorited = true
            this.$toasted.info(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
            if (error.response.data.errors != null) {
              this.$refs.observer.setErrors(error.response.data.errors)
              this.waiting = true
            }
          }
        })

      this.processing = false
    },

    async onUnFavorite () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.favoriteDeleteUrl.replace('_id', this.$route.params.id), {
        user_id: this.$auth.user.id,
        article_id: this.article.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.isFavorited = false
            this.$toasted.info(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
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
