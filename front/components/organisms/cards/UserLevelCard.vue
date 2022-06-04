<template>
  <div>
    <v-row class="py-5">
      <v-col cols="6">
        <v-row justify="center">
          <h1>Lv.{{ getLevel }}</h1>
        </v-row>
        <v-row justify="center">
          <span>Level</span>
        </v-row>
      </v-col>
      <v-col cols="6">
        <v-row justify="center">
          <h1>{{ getLifelongPoint }}</h1>
        </v-row>
        <v-row justify="center">
          <span>合計EXP</span>
        </v-row>
      </v-col>
    </v-row>
    <PointProgressLinear
      :required-point="requiredPoint"
      :point-to-next="getPointToNext"
      class="pb-2"
    />
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    },
    requiredPoint: {
      type: Number,
      default: 0
    }
  },
  computed: {
    getLevel () {
      return this.user && this.user.level
    },
    getLifelongPoint () {
      return this.user && this.user.lifelong_point
    },
    getPointToNext () {
      return this.user && this.user.point_to_next
    }
  }
}
</script>
