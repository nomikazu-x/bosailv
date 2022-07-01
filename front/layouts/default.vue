<template>
  <v-app dark>
    <TheHeader />

    <TheSidebar />

    <LevelUpModal />

    <v-main style="background-color: #f9f5eb;">
      <nuxt />
    </v-main>

    <TheFooter />
    <GoTop :max-width="48" :size="48" :right="24" :bottom="24" bg-color="#ef5350" />
  </v-app>
</template>

<script>
import GoTop from '@inotom/vue-go-top'

export default {
  name: 'LayoutsDefault',
  components: {
    GoTop
  }
}
</script>
