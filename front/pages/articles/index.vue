<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <div v-for="category in categories" :key="category.id">
        <v-checkbox
          v-model="selectedCategories"
          :value="category.value"
          :label="category.name"
          dense
        />
      </div>
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
          <div v-if="list.category.includes(selectedCategories)">
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
      lists: null,
      categories: [
        { name: '電気・ガス', value: 'gas' },
        { name: '水道', value: 'watersuppry' },
        { name: '応急', value: 'emergency' },
        { name: '災害時の知恵', value: 'knowledge' },
        { name: '地震', value: 'earthquake' },
        { name: '津波', value: 'tsunami' },
        { name: '火山噴火', value: 'volcano' },
        { name: '大雪', value: 'snow' },
        { name: '台風', value: 'typhoon' },
        { name: '内水氾濫', value: 'internalwater' },
        { name: '河川洪水', value: 'riverflood' },
        { name: '土砂災害', value: 'landslide' },
        { name: '強風', value: 'strongwind' },
        { name: '熱中症', value: 'heatstroke' },
        { name: '防災情報', value: 'warning' },
        { name: '国民保護情報', value: 'jalert' }
      ],
      selectedCategories: {}
    }
  },

  async created () {
    await this.onPagination(this.page)
    this.loading = false
  },

  methods: {
    async onPagination () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, { params: { page: this.page } })
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
