<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading" max-width="480px">
      <Processing v-if="processing" />
      <ValidationObserver v-slot="{ invalid }" ref="observer">
        <v-form autocomplete="off">
          <v-card-title>記事編集</v-card-title>
          <v-card-text>
            <ValidationProvider v-slot="{ errors }" name="title" rules="required">
              <v-text-field
                v-model="title"
                label="タイトル"
                prepend-icon="mdi-pencil"
                autocomplete="off"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <ValidationProvider v-slot="{ errors }" name="content" rules="required">
              <quill-editor
                v-model="content"
                :error-messages="errors"
              />
            </ValidationProvider>
            <v-btn id="article_create_btn" color="primary" :disabled="invalid || processing || waiting" @click="onArticleUpdate()">編集</v-btn>
          </v-card-text>
        </v-form>
      </ValidationObserver>
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersSignUp',

  mixins: [Application],

  data () {
    return {
      waiting: false,
      title: '',
      content: ''
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.article = response.data.article
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/' })
      })
    this.title = this.title || this.article.title
    this.content = this.content || this.article.content
    this.processing = false
    this.loading = false
  },

  methods: {
    async onArticleUpdate () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleUpdateUrl.replace('_id', this.$route.params.id), {
        title: this.title,
        content: this.content
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            return this.$router.push({ path: '/articles' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
            if (error.response.data.errors != null) {
              this.$refs.observer.setErrors(error.response.data.errors)
              this.waiting = true
            }
          }
        })

      this.processing = false
    }
  }
}
</script>
