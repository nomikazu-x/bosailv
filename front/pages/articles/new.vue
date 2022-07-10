<template>
  <OneColumnContainer class="pos-relative" fluid>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleNewCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import ArticleNewCard from '~/components/organisms/cards/article/ArticleNewCard.vue'

export default {
  name: 'ArticlesNew',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    ArticleNewCard
  },

  mixins: [Application],

  created () {
    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }
    this.loading = false
  }
}
</script>
