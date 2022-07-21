<template>
  <v-card outlined tile>
    <TheProcessing v-if="processing" />
    <v-col v-for="task in $auth.user.sns_tasks" :key="task.name" cols="12">
      <v-card-title class="font-weight-bold">
        {{ task.name }}
      </v-card-title>
      <v-divider class="my-5" />
      <v-card-text v-if="task">
        {{ task.is_completed }}
      </v-card-text>
    </v-col>
  </v-card>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'SnsTaskCard',

  mixins: [Application],

  // data () {
  //   return {
  //     user: null
  //   }
  // },
  created () {
    this.processing = false
  }
}
</script>
