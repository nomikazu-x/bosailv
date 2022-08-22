<template>
  <v-row v-if="task != null" justify="center">
    <v-col cols="12" sm="10" md="8">
      <BaseTitleCard title="防災タスク編集" />
      <TaskEditForm
        :task="task"
        :processing="processing"
        @task-update="onTaskUpdate"
        @task-delete="onTaskDelete"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import TaskEditForm from '~/components/organisms/form/TaskEditForm.vue'

export default {
  name: 'TaskEditCard',

  components: {
    BaseTitleCard,
    TaskEditForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null,
      task: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.taskShowUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.task = response.data.task
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

    this.processing = false
  },

  methods: {
    async onTaskUpdate (taskInfo) {
      this.processing = true

      const params = new FormData()
      params.append('task[title]', taskInfo.title)
      params.append('task[summary]', taskInfo.summary)
      params.append('task[body]', taskInfo.body)
      if (taskInfo.image) {
        params.append('task[image]', taskInfo.image)
      }

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminTaskUpdateUrl.replace('_id', this.$route.params.id), params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
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
    },

    async onTaskDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminTaskDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            return this.$router.push({ path: '/admin/tasks' })
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
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
