<template>
  <v-row v-if="users != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="記事検索">
        <v-row class="pa-5">
          <v-col cols="12">
            <SearchTextField v-model="keyword" />
          </v-col>
          <v-col cols="12">
            <div class="text-center mt-5">
              <RedBtn @click="onSearchUserPagination">検索</RedBtn>
            </div>
          </v-col>
        </v-row>
        <v-row justify="center">
          <v-col cols="12">
            <v-card-title v-if="info">検索結果：{{ info.total_count }}件</v-card-title>
          </v-col>
          <v-col cols="12">
            <UserListWithTab
              :users="users"
              :info="info"
              :processing="processing"
              @pagination="onSearchUserPagination"
            />
          </v-col>
        </v-row>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import SearchTextField from '~/components/organisms/textFields/SearchTextField.vue'
import UserListWithTab from '~/components/organisms/tabItem/UserListWithTab.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'ArticleSearchListCard',

  components: {
    BaseTitleCard,
    SearchTextField,
    UserListWithTab,
    RedBtn
  },

  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      users: null,
      keyword: ''
    }
  },

  created () {
    this.onSearchUserPagination(this.page)
    this.processing = false
  },

  methods: {
    async onSearchUserPagination (value) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.usersSearchUrl, {
        params: {
          page: value,
          keyword: this.keyword
        }
      })
        .then((response) => {
          if (response.data == null || response.data.user == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.user
            this.users = response.data.users
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.info == null) {
            return this.$router.push({ path: '/' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
