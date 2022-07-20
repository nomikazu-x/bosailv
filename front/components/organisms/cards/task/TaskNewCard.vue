<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8">
      <BaseTitleCard title="防災タスク作成" />
      <TaskNewForm
        :processing="processing"
        @task-create="onTaskCreate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import TaskNewForm from '~/components/organisms/form/TaskNewForm.vue'

export default {
  name: 'TaskNewCard',

  components: {
    BaseTitleCard,
    TaskNewForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },
  created () {
    this.processing = false
  },

  methods: {
    async onTaskCreate (taskInfo) {
      this.processing = true

      const params = new FormData()
      params.append('task[title]', taskInfo.title)
      params.append('task[image]', taskInfo.image)
      params.append('task[summary]', taskInfo.summary)
      params.append('task[body]', taskInfo.body)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminTaskCreateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.$router.push({ path: '/admin/tasks' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
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
