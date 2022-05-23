<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <ValidationProvider v-slot="{ errors }" name="keyword" rules="required">
        <v-text-field
          v-model="keyword"
          label="検索"
          prepend-icon="mdi-magnify"
          :error-messages="errors"
          @keyup="onSearchArticles"
        />
      </ValidationProvider>
      <v-card-text>
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
            <div class="ml-1">
              {{ list.category }}
            </div>
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div v-if="list.content" class="mx-2 my-2" v-html="list.content" />
            <v-divider class="my-4" />
          </div>
        </article>
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
      lists: null,
      keyword: ''
    }
  },

  created () {
    this.processing = false
    this.loading = false
  },

  methods: {
    async onSearchArticles () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesSearchUrl, {
        params: { keyword: this.keyword }
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
