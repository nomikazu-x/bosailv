<template>
  <BaseTitleCard title="防災SNSフォロータスク">
    <TheProcessing v-if="processing" />
    <v-card v-for="task in $auth.user.sns_tasks" :key="task.name" class="my-3" tile>
      <v-row align="center">
        <v-col cols="8">
          <v-card-subtitle>
            {{ task.name }}
          </v-card-subtitle>
        </v-col>
        <v-col cols="4">
          <div class="text-center">
            <CompleteBtnGroup
              v-if="$auth.loggedIn"
              :task="task"
              @complete="onComplete(task.value)"
              @un-complete="onUnComplete(task.value)"
            />
          </div>
        </v-col>
      </v-row>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import CompleteBtnGroup from '~/components/organisms/btnGroup/CompleteBtnGroup.vue'

export default {
  name: 'SnsTaskCard',

  components: {
    BaseTitleCard,
    CompleteBtnGroup
  },

  mixins: [Application],

  created () {
    this.processing = false
  },

  methods: {
    async onComplete (task) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userTaskUpdateUrl, {
        sns_tasks: task
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setPoint', response.data.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_point, { root: true })
            this.$toasted.info(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    },

    async onUnComplete (task) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userTaskDeleteUrl, {
        sns_tasks: task
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setPoint', response.data.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_point, { root: true })
            this.$toasted.info(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
