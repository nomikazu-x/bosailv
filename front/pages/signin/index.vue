<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <SigninCard v-if="!loading" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import SigninCard from '~/components/organisms/cards/SigninCard.vue'

export default {
  name: 'SigninIndex',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    SigninCard
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
