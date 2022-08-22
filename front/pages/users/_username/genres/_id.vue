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
      <UserIntroCard class="mb-4" />
      <UserMenusCard />
    </template>

    <template v-if="!loading" #right>
      <UserArticleListCard />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import UserIntroCard from '~/components/organisms/cards/user/UserIntroCard.vue'
import UserMenusCard from '~/components/organisms/cards/user/UserMenusCard.vue'
import UserArticleListCard from '~/components/organisms/cards/user/UserArticleListCard.vue'

export default {
  name: 'UsersUsernameGenresId',

  components: {
    TwoColumnContainer,
    TheLoading,
    TheMessage,
    UserIntroCard,
    UserMenusCard,
    UserArticleListCard
  },

  mixins: [Application],

  created () {
    this.loading = false
  }
}
</script>
