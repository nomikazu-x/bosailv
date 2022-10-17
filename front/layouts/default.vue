<template>
  <v-app dark>
    <TheHeader />

    <TheSidebar />

    <TheLevelUpDialog />

    <v-main :style="bgColorPath">
      <TheDestroyInfo />
      <nuxt />
    </v-main>

    <TheFooter />
    <GoTop v-if="!isGoTopValidPath" :max-width="48" :size="48" :right="24" :bottom="24" bg-color="#117768" />
  </v-app>
</template>

<script>
import GoTop from '@inotom/vue-go-top'
import TheHeader from '~/components/organisms/header/TheHeader.vue'
import TheSidebar from '~/components/organisms/sidebar/TheSidebar.vue'
import TheLevelUpDialog from '~/components/organisms/dialogs/TheLevelUpDialog.vue'
import TheDestroyInfo from '~/components/organisms/application/TheDestroyInfo.vue'
import TheFooter from '~/components/organisms/footer/TheFooter.vue'

export default {
  name: 'LayoutsDefault',

  components: {
    TheHeader,
    TheSidebar,
    TheLevelUpDialog,
    TheFooter,
    TheDestroyInfo,
    GoTop
  },

  computed: {
    isGoTopValidPath () {
      const currentPath = this.$route.name
      return (currentPath === 'articles-id-edit___ja') || (currentPath === 'articles-new___ja')
    },
    bgColorPath () {
      const currentPath = this.$route.name
      return (currentPath === 'about___ja') ? 'background-color: #DFEEE5;' : 'background-color: #f9f5eb;'
    }
  }
}
</script>
