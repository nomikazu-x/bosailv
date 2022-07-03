<template>
  <OneColumnContainer class="pos-relative" fluid>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <LikerCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesIdLikers',

  mixins: [Application],

  created () {
    this.loading = false
  }
}
</script>
