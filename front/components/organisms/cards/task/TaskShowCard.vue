<template>
  <v-card v-if="task != null" outlined tile>
    <TheProcessing v-if="processing" />
    <v-img :src="task.image_url.xlarge" max-height="256" />
    <v-col cols="12">
      <v-card-title class="font-weight-bold">
        {{ task.title }}
      </v-card-title>
      <v-divider class="my-5" />
      <v-card-text v-if="task">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-if="task.body" class="mx-2 my-2" v-html="task.body" />
      </v-card-text>
      <v-divider class="my-5" />
      <div class="text-center">
        <CompleteBtnGroup v-if="$auth.loggedIn" :task="task" />
      </div>
    </v-col>
  </v-card>
</template>

<script>
import Application from '~/plugins/application.js'
import CompleteBtnGroup from '~/components/organisms/btnGroup/CompleteBtnGroup.vue'

export default {
  name: 'TaskShowCard',

  components: {
    CompleteBtnGroup
  },

  mixins: [Application],

  data () {
    return {
      user: null,
      task: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.taskShowUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.task = response.data.task
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

    this.processing = false
  }
}
</script>
