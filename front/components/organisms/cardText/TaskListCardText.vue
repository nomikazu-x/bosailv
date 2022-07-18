<template>
  <BaseCard :to="toTask(task)">
    <v-card-text class="black--text">
      <v-row>
        <v-col cols="4" align="center">
          <v-img :src="task.image_url.large" max-height="128" max-width="192" class="ml-5 mt-2 rounded-lg" />
        </v-col>
        <v-col cols="8">
          <v-card-title class="font-weight-bold">
            {{ task.title }}
            <span v-if="task.is_completed" class="article-title ml-2 white--text text-center">済</span>
          </v-card-title>
          <v-card-text>
            {{ task.summary }}
          </v-card-text>
        </v-col>
      </v-row>
    </v-card-text>
  </BaseCard>
</template>

<script>
import BaseCard from '~/components/molecules/cards/BaseCard.vue'

export default {
  name: 'TaskListCardText',

  components: {
    BaseCard
  },

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
