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
        { id: 1, to: '/hazard_maps', icon: 'mdi-book-multiple', title: 'ハザードマップ', summary: '災害は突然やってきます。思い立ったときにハザードマップを確認しておきましょう。' },
        { id: 2, to: '/shelters', icon: 'mdi-exit-run', title: '避難所', summary: 'いざというときにあわてないように、近くにある避難場所をしっかり確認しておきましょう。' },
        { id: 3, to: '/sns_tasks', icon: 'mdi-twitter', title: '防災SNS', summary: '災害時に役立つ情報を発信しているSNSアカウントをフォローしておきましょう。' },
        { id: 4, to: '/house_tasks', icon: 'mdi-home', title: '家具の固定', summary: 'おうち防災タスクをこなして、震災時のけがから身を守りましょう。' },
        { id: 5, to: '/family_rule', icon: 'mdi-human-male-female-child', title: '家族会議', summary: 'いざというときに備えて、家族会議をして各項目をメモしておきましょう。' },
        { id: 6, to: '/emergency_contacts', icon: 'mdi-phone-in-talk', title: '緊急連絡先', summary: '緊急連絡先を登録して、災害時すぐに連絡できるようにしておきましょう。' },
        { id: 7, to: '/stocks', icon: 'mdi-archive', title: '備蓄', summary: 'ライフラインが止まった場合や、避難生活が必要になったときのために防災用品を備えましょう。' }
      ],
      tasks: null
    }
  },

  computed: {
    toTask () {
      return (task) => {
        if (this.$route.path === '/admin/tasks') {
          return { name: 'admin-tasks-id-edit___ja', params: { id: task.id } }
        } else {
          return { name: 'tasks-id___ja', params: { id: task.id } }
        }
      }
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
