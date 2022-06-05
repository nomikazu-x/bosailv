<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <v-card-text>
        <v-row v-if="info != null && info.total_count > info.limit_value">
          <v-col cols="auto" md="5" align-self="center">
            {{ info.total_count.toLocaleString() }}件中 {{ $pageFirstNumber(info).toLocaleString() }}-{{ $pageLastNumber(info).toLocaleString() }}件を表示
          </v-col>
          <v-col cols="auto" md="7" class="d-flex justify-end">
            <v-pagination id="pagination" v-model="page" :length="info.total_pages" @input="onPagination()" />
          </v-col>
        </v-row>

        <v-divider class="my-4" />
        <article v-if="lists != null && lists.length === 0">
          <span class="ml-1">記事はありません。</span>
          <v-divider class="my-4" />
        </article>
        <article v-for="list in lists" :key="list.id">
          <div>
            <span class="ml-1 font-weight-bold">
              <NuxtLink :to="{ name: 'articles-id___ja', params: { id: list.id }}">{{ list.title }}</NuxtLink>
            </span>
            <span class="ml-1">
              ({{ $dateFormat(list.created_at, 'ja') }})
            </span>
            <v-divider class="my-4" />
          </div>
        </article>

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
  name: 'Articles',

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
    this.loading = false
  },

  methods: {
    async onPagination () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: this.page }
      })
        .then((response) => {
          if (response.data == null || response.data.article == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.article
            this.lists = response.data.articles
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
