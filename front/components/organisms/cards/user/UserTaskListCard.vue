<template>
  <div v-if="tasks != null && constantTasks != null">
    <BaseTitleCard title="防災タスク一覧" style="background-color: #f9f5eb;" />
    <TaskListCardText
      v-for="task in constantTasks"
      :key="`first-${task.id}`"
      :task="task"
      :to="toUserTask(task)"
      class="mt-2"
    />
    <TaskListCardText
      v-for="task in tasks"
      :key="`second-${task.id}`"
      :task="task"
      :to="toAdminTaskOrTaskId(task)"
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
      user: null,
      tasks: null
    }
  },

  computed: {
    toAdminTaskOrTaskId () {
      return (task) => {
        if (this.$route.path === '/admin/tasks') {
          return { name: 'admin-tasks-id-edit___ja', params: { id: task.id } }
        } else if (this.canAction) {
          return { name: 'tasks-id___ja', params: { id: task.id } }
        } else {
          return null
        }
      }
    },
    toUserTask () {
      return (task) => {
        return this.canAction ? task.to : null
      }
    },
    authUsername () {
      return this.$auth.user.username
    },
    canAction () {
      return this.$auth.loggedIn
        ? this.currentUsername === this.authUsername
        : false
    },
    currentUsername () {
      return this.$route.params.username || this.$auth.user.username
    },
    constantTasks () {
      if (this.user != null) {
        return [
          { id: 1, to: '/hazard_maps', is_completed: this.user.is_hazard_map_confirmed, icon: 'mdi-book-multiple', title: 'ハザードマップ', summary: '思い立ったときにハザードマップを確認しましょう。' },
          { id: 2, to: '/shelters', is_completed: this.user.is_shelter_registered, icon: 'mdi-exit-run', title: '避難所', summary: 'いざという時に慌てないように、近くにある避難所を確認しましょう。' },
          { id: 3, to: '/sns_tasks', is_completed: this.user.is_completed_sns_tasks, icon: 'mdi-twitter', title: '防災SNS', summary: '災害時に役立つ情報を発信しているSNSアカウントをフォローしましょう。' },
          { id: 4, to: '/house_tasks', is_completed: this.user.is_completed_house_tasks, icon: 'mdi-home', title: '家具の固定', summary: 'おうち防災タスクをこなして、震災時のけがから身を守りましょう。' },
          { id: 5, to: '/family_rule', is_completed: this.user.is_completed_family_rules_tasks, icon: 'mdi-human-male-female-child', title: '家族会議', summary: 'いざというときに備えて、家族会議をして各項目をメモしましょう。' },
          { id: 6, to: '/emergency_contacts', is_completed: this.user.is_completed_emergency_contact_task, icon: 'mdi-phone-in-talk', title: '緊急連絡先', summary: '緊急連絡先を登録して、災害時すぐに連絡できるようにしましょう。' },
          { id: 7, to: '/stocks', is_completed: this.user.is_completed_stock_tasks, icon: 'mdi-archive', title: '備蓄', summary: '避難生活が必要になった時のために防災用品を備えましょう。' }
        ]
      } else {
        return null
      }
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
        } else {
          this.user = response.data.user
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
        return this.$router.push({ path: '/home' })
      })

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
