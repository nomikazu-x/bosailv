<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading">
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
              <quill-editor
                v-model="content"
                :error-messages="errors"
              />
            </ValidationProvider>
            <div v-for="category in categories" :key="category.id">
              <v-checkbox
                v-model="selectedCategories"
                :value="category.value"
                :label="category.name"
              />
            </div>
            <v-btn id="article_create_btn" color="primary" :disabled="invalid || processing || waiting" @click="onArticleCreate()">作成</v-btn>
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
      content: '',
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
      selectedCategories: []
    }
  },

  created () {
    this.processing = false
    this.loading = false
  },

  methods: {
    async onArticleCreate () {
      this.processing = true

      const formData = new FormData()
      formData.append('article[title]', this.title)
      formData.append('article[content]', this.content)
      this.selectedCategories.forEach((category) => {
        formData.append('article[category][]', category)
      })

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleCreateUrl, formData)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setPoint', response.data.article.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_exp, { root: true })
            this.$store.commit('articles/addArticles', response.data.article, { root: true })
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
