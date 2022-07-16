<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <AdminMenusCard />
    </template>

    <template v-if="!loading" #right>
      <ArticleSearchListCard />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import AdminMenusCard from '~/components/organisms/cards/admin/AdminMenusCard.vue'
import ArticleSearchListCard from '~/components/organisms/cards/article/ArticleSearchListCard.vue'

export default {
  name: 'AdminArticlesSearch',

  components: {
    TwoColumnContainer,
    TheLoading,
    TheMessage,
    AdminMenusCard,
    ArticleSearchListCard
  },

  mixins: [Application],

  created () {
    if (!this.$auth.user.admin) {
      return this.redirectNotAdmin()
    }
    this.loading = false
  }
}
</script>
