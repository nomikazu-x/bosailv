<template>
  <div>
    <BaseTitleCard v-if="tasks != null" title="防災タスク一覧" style="background-color: #f9f5eb;" />
    <TaskListCardText
      v-for="task in tasks"
      :key="task.id"
      :task="task"
      class="mt-2"
    />
  </div>
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
    await this.$axios.get(this.$config.apiBaseURL + this.$config.tasksUrl, {
      params: { username: this.$route.params.username }
    })
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
