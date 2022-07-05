<template>
  <OneColumnContainer class="pos-relative" fluid>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleLikerListCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import ArticleLikerListCard from '~/components/organisms/cards/article/ArticleLikerListCard.vue'

export default {
  name: 'ArticlesIdLikers',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    ArticleLikerListCard
  },

  mixins: [Application],

  created () {
    this.loading = false
  }
}
</script>
