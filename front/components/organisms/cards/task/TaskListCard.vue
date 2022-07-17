<template>
  <BaseTitleCard v-if="tasks != null" title="防災タスク一覧">
    <v-card v-for="task in tasks" :key="task.id">
      <TaskListCardText
        :task="task"
        class="px-2"
      />
    </v-card>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import TaskListCardText from '~/components/organisms/cardText/TaskListCardText.vue'

export default {
  name: 'TaskListCard',

  components: {
    BaseTitleCard,
    TaskListCardText
  },

  mixins: [Application],
  data () {
    return {
      tasks: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.tasksUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.tasks = null
        } else {
          this.tasks = response.data.tasks
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

    this.processing = false
  }
}
</script>
