<template>
  <v-row justify="center" align="center">
    <v-col lg="8" cols="9" class="mr-1">
      <v-progress-linear height="10px" background-color="green lighten-3" color="green darken-3" :value="progressProportion" />
    </v-col>
    <v-col cols="2" lg="2" class="py-0">
      <div v-if="!maxLevel" class="float-right">
        {{ progressNumeretor }}/{{ requiredPoint }}
      </div>
      <div v-else>
        MAX
      </div>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    requiredPoint: {
      type: Number,
      default: 0
    },
    pointToNext: {
      type: Number,
      default: 0
    }
  },
  computed: {
    progressProportion () {
      if (this.maxLevel) {
        return 100
      }
      const proportion = 100 - this.pointToNext / this.requiredPoint * 100
      if (proportion === 100) {
        return 0
      } else {
        return proportion
      }
    },
    maxLevel () {
      if (this.requiredPoint === 1660) {
        return true
      }
      return false
    },
    progressNumeretor () {
      return this.requiredPoint - this.pointToNext
    }
  }
}
</script>
