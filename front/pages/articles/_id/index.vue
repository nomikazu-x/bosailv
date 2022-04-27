<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <v-card-title v-if="list">
        <span class="ml-1 font-weight-bold">
          {{ list.title }}
        </span>
        <span class="ml-1">
          ({{ $dateFormat(list.created_at, 'ja') }})
        </span>
      </v-card-title>
      <v-card-text v-if="list">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-if="list.content" class="mx-2 my-2" v-html="list.content" />
      </v-card-text>
      <v-divider />
      <v-card-actions>
        <ul class="my-2">
          <li><NuxtLink :to="`/articles/${$route.params.id}/edit`">編集</NuxtLink></li>
        </ul>
      </v-card-actions>
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
      list: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.list = response.data.article
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.loading = false
  }
}
</script>
