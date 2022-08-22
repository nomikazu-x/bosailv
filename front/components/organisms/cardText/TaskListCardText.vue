<template>
  <v-card :to="to" outlined class="mb-3 rounded-lg">
    <v-row class="black--text" no-gutters align="center">
      <v-col v-if="$auth.loggedIn && task.is_completed" cols="1">
        <v-sheet height="132" color="#117768" class="rounded-l-lg" />
      </v-col>
      <v-col v-else cols="1">
        <v-sheet height="132" color="#DFEEE5" class="rounded-l-lg" />
      </v-col>
      <v-col cols="11">
        <v-row align="center">
          <v-col cols="9">
            <v-card-title class="font-weight-bold">
              {{ task.title }}
            </v-card-title>
            <v-card-text>
              {{ task.summary }}
            </v-card-text>
          </v-col>
          <v-col cols="3">
            <GreenBtn v-if="!task.is_completed" disabled outlined small class="mr-1">未達成</GreenBtn>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'TaskListCardText',

  components: {
    GreenBtn
  },

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
  background: #DFEEE5;
  width: 30px;
  height: 30px;
}
</style>
