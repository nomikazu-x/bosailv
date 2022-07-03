<template>
  <OneColumnContainer>
    <h1 class="main-heading mb-8 text-center">BosaiLevel</h1>

    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <SigninCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'SigninIndex',

  mixins: [Application],

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    this.loading = false
  }
}
</script>
