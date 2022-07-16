<template>
  <OneColumnContainer class="pos-relative" fluid>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleEditCard v-if="!loading" :article="article" @article="article = $event" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import ArticleEditCard from '~/components/organisms/cards/article/ArticleEditCard.vue'

export default {
  name: 'ArticlesIdEdit',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    ArticleEditCard
  },

  mixins: [Application],

  data () {
    return {
      article: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.article = response.data.article
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/' })
      })

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    if (!(this.$auth.user.id === this.article.user.id || this.$auth.user.admin)) {
      this.$toasted.error(this.$t('auth.not_permission'))
      this.$router.push({ path: '/' })
    }

    this.loading = false
  }
}
</script>
