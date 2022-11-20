<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <UserConfirmationNewCard v-if="!loading" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import UserConfirmationNewCard from '~/components/organisms/cards/UserConfirmationNewCard.vue'

export default {
  name: 'UserConfirmationNew',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    UserConfirmationNewCard
  },

  mixins: [Application],

  created () {
    this.setQueryMessage()
    this.loading = false
  }
}
</script>
