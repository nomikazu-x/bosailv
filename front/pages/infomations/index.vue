<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>通知一覧</v-card-title>
      <v-card-text>
        <v-row v-if="info != null && info.total_count > info.limit_value">
          <v-col cols="auto" md="5" align-self="center">
            {{ info.total_count.toLocaleString() }}件中 {{ $pageFirstNumber(info).toLocaleString() }}-{{ $pageLastNumber(info).toLocaleString() }}件を表示
          </v-col>
          <v-col cols="auto" md="7" class="d-flex justify-end">
            <v-pagination id="pagination" v-model="page" :length="info.total_pages" @input="onPagination()" />
          </v-col>
        </v-row>

        <article v-if="lists != null && lists.length === 0">
          <span class="ml-1">お知らせはありません。</span>
          <v-divider class="my-4" />
        </article>
        <v-list v-for="list in lists" :key="list.id">
          <v-divider class="mb-4" />
          <InfomationLabel :list="list" />
          <div v-if="list.article_id_present === true">
            <v-list-item :to="{ name: 'articles-id___ja', params: { id: list.article_id }}">
              <v-icon class="mr-4">mdi-account-heart</v-icon>
              <v-list-item-title>{{ list.title }}</v-list-item-title>
              <span>
                ({{ $dateFormat(list.started_at, 'ja') }})
              </span>
            </v-list-item>
          </div>
          <div v-else>
            <div v-if="list.body_present === true">
              <v-list-item :to="{ name: 'infomations-id___ja', params: { id: list.id }}">
                <v-icon class="mr-4">mdi-bell</v-icon>
                <v-list-item-title>{{ list.title }}</v-list-item-title>
                <!-- eslint-disable-next-line vue/no-v-html -->
                <v-list-item-subtitle v-if="list.summary" v-html="list.summary" />
                <span>
                  ({{ $dateFormat(list.started_at, 'ja') }})
                </span>
              </v-list-item>
            </div>
            <div v-else>
              <v-list-item>
                <v-icon class="mr-4">mdi-bell</v-icon>
                <v-list-item-title>
                  {{ list.title }}
                </v-list-item-title>
                <span>
                  ({{ $dateFormat(list.started_at, 'ja') }})
                </span>
              </v-list-item>
            </div>
          </div>
        </v-list>

        <div v-if="info != null && info.total_pages > 1">
          <v-pagination id="pagination2" v-model="page" :length="info.total_pages" @input="onPagination()" />
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Infomations',
  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      lists: null
    }
  },

  async created () {
    await this.onPagination(this.page)

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    this.loading = false
  },

  methods: {
    async onPagination () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.infomationsUrl, { params: { page: this.page } })
        .then((response) => {
          if (response.data == null || response.data.infomation == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.infomation
            this.lists = response.data.infomations
            if (this.$auth.loggedIn && this.$auth.user.infomation_unread_count !== 0 && this.page === 1) { this.$auth.fetchUser() } // Tips: お知らせ未読数をリセット
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
