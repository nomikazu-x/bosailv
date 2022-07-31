<template>
  <v-card :to="to" outlined class="mb-3 rounded-lg">
    <v-row class="black--text" no-gutters>
      <v-col v-if="$auth.loggedIn && task.is_completed" cols="1">
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
            <div v-if="!task.is_completed" class="ml-2 article-title text-center white--text">未</div>
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
    },
    to: {
      type: [Object, String],
      default: null
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
