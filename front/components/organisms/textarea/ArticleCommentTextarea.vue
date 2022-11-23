<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <ValidationProvider v-slot="{ errors }" name="content" rules="required|max:300">
          <v-textarea
            v-model="content"
            label="コメント"
            color="#117768"
            outlined
            autocomplete="off"
            :error-messages="errors"
            @click="waiting = false"
          />
        </ValidationProvider>
        <OrangeBtn id="comment_create_btn" :disabled="invalid || processing || waiting" @click="onCommentCreate()">作成</OrangeBtn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'ArticleCommentTextarea',

  components: {
    ValidationObserver,
    ValidationProvider,
    OrangeBtn
  },

  mixins: [Application],

  props: {
    article: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      waiting: false,
      content: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onCommentCreate () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.commentCreateUrl.replace('_article_id', this.$route.params.id), {
        content: this.content
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('articleComments/addArticleComments', response.data.comment, { root: true })
            this.content = ''
            this.$refs.observer.reset()
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
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
