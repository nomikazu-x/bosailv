<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard v-if="users != null && articles != null" title="一覧">
        <v-tabs v-model="tab" background-color="#FFFCFC" color="#117768" grow>
          <v-tab v-for="title in titles" :key="title.name">{{ title.name }}</v-tab>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item>
            <UserListWithTab
              :processing="processing"
              :users="users"
              :info="userInfo"
              @pagination="onUserPagination"
            />
          </v-tab-item>
          <v-tab-item>
            <ArticleListCardWithTab
              :processing="processing"
              :articles="articles"
              :info="articleInfo"
              @pagination="onArticlePagination"
            />
          </v-tab-item>
        </v-tabs-items>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from 'vuex'
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import UserListWithTab from '~/components/organisms/tabItem/UserListWithTab.vue'
import ArticleListCardWithTab from '~/components/organisms/tabItem/ArticleListCardWithTab.vue'

export default {
  name: 'UsefulArticleListCard',

  components: {
    BaseTitleCard,
    UserListWithTab,
    ArticleListCardWithTab
  },

  mixins: [Application],

  data () {
    return {
      tab: null,
      titles: [
        { name: 'ユーザー' },
        { name: '記事' }
      ],
      articlePage: 1,
      articleInfo: null,
      articles: null,
      userPage: 1,
      userInfo: null
    }
  },

  computed: {
    ...mapGetters({
      users: 'user/users'
    })
  },

  async created () {
    await this.onUserPagination(this.userPage)
    await this.onArticlePagination(this.articlePage)
    this.loading = false
  },

  methods: {
    async onUserPagination (userPage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.adminUsersUrl, {
        params: { page: userPage }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.userInfo == null) {
              return this.$router.push({ path: '/home' })
            }
            this.userPage = this.userInfo.current_page
          } else {
            this.userInfo = response.data.user
            this.$store.commit('user/setUsers', response.data.users, { root: true })
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.userInfo == null) {
            return this.$router.push({ path: '/home' })
          }
          this.userPage = this.userInfo.current_page
        })

      this.processing = false
    },
    async onArticlePagination (articlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: articlePage }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.articleInfo == null) {
              return this.$router.push({ path: '/home' })
            }
            this.articlePage = this.articleInfo.current_page
          } else {
            this.articleInfo = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.articleInfo == null) {
            return this.$router.push({ path: '/home' })
          }
          this.articlePage = this.articleInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
