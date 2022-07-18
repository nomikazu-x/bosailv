<template>
  <v-card :to="toTask(task)" outlined class="mb-3 rounded-lg">
    <v-row class="black--text" no-gutters>
      <v-col v-if="task.is_completed" cols="1">
        <v-sheet height="132" color="red" class="rounded-l-lg" />
      </v-col>
      <v-col v-else cols="1">
        <v-sheet height="132" color="grey" class="rounded-l-lg" />
      </v-col>
      <v-row align="center">
        <v-col cols="3">
          <v-img :src="task.image_url.large" max-height="128" max-width="192" class="ml-2 mt-1 rounded-lg" />
        </v-col>
        <v-col cols="8">
          <v-card-title class="font-weight-bold">
            {{ task.title }}
          </v-card-title>
          <v-card-text>
            {{ task.summary }}
          </v-card-text>
        </v-col>
      </v-row>
    </v-row>
  </v-card>
</template>

<script>
export default {
  name: 'TaskListCardText',

  props: {
    task: {
      type: Object,
      default: null
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
  }
}
</script>

<style lang="scss" scoped>
.article-title {
  background: rgba(0, 0, 0, 0.5);
  width: 30px;
  height: 30px;
}
</style>
