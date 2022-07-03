<template>
  <OneColumnContainer class="pos-relative" fluid>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleNewCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesNew',

  mixins: [Application],

  created () {
    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }
    this.loading = false
  }
}
</script>
