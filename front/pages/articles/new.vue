<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading" max-width="480px">
      <Processing v-if="processing" />
      <ValidationObserver v-slot="{ invalid }" ref="observer">
        <v-form autocomplete="off">
          <v-card-title>記事作成</v-card-title>
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
              <v-textarea
                v-model="content"
                label="内容"
                prepend-icon="mdi-pencil"
                autocomplete="off"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <v-btn id="article_create_btn" color="primary" :disabled="invalid || processing || waiting" @click="onPost()">作成</v-btn>
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

  created () {
    this.processing = false
    this.loading = false
  },

  methods: {
    async onPost () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleCreateUrl, {
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
