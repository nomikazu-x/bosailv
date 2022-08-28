<template>
  <div v-if="tasks != null">
    <BaseTitleCard title="防災タスク一覧" style="background-color: #f9f5eb;" />
    <TaskListCardText
      v-for="task in constantTasks"
      :key="`first-${task.id}`"
      :task="task"
      :to="task.to"
      class="mt-2"
    />
    <TaskListCardText
      v-for="task in tasks"
      :key="`second-${task.id}`"
      :task="task"
      :to="toTask(task)"
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
      constantTasks: [
        { id: 1, to: '/sns_tasks', title: '防災SNSをフォローしよう!', summary: '防災SNSをフォローしてもしものときに備えよう。' },
        { id: 2, to: '/house_tasks', title: '家具の固定をしよう!', summary: '家具類の転倒・落下・移動防止対策をしてもしものときに備えよう。' },
        { id: 3, to: '/family_rule', title: '家族会議しよう!', summary: '災害に備えて家族でルールを決めておきましょう。' },
        { id: 4, to: '/emergency_contacts', title: '緊急連絡先を登録しよう!', summary: '緊急時にそなえて連絡先を登録しておこう。' },
        { id: 5, to: '/stocks', title: '災害用備蓄をしよう!', summary: '家族構成を登録して、必要な備蓄品を備蓄しておこう。' }
      ],
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
