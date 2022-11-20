<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <UserUnlockNewCard v-if="!loading" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import UserUnlockNewCard from '~/components/organisms/cards/UserUnlockNewCard.vue'

export default {
  name: 'UserUnlockNew',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    UserUnlockNewCard
  },

  mixins: [Application],

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }

    this.setQueryMessage()
    this.loading = false
  }
}
</script>
