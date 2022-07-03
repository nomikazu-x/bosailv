<template>
  <v-app dark>
    <TheHeader />

    <TheSidebar />

    <LevelUpModal />

    <v-main style="background-color: #f9f5eb;">
      <nuxt />
    </v-main>

    <TheFooter />
    <GoTop v-if="!isGoTopValidPath" :max-width="48" :size="48" :right="24" :bottom="24" bg-color="#ef5350" />
  </v-app>
</template>

<script>
import GoTop from '@inotom/vue-go-top'

export default {
  name: 'LayoutsDefault',
  components: {
    GoTop
  },
  computed: {
    isGoTopValidPath () {
      const currentPath = this.$route.name
      return (currentPath === 'articles-id-edit___ja') || (currentPath === 'articles-new___ja')
    }
  }
}
</script>
