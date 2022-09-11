<template>
  <BaseCard :to="{ name: 'shelters-id___ja', params: { id: shelter.id }}">
    <v-card-text class="black--text">
      <v-row>
        <v-col cols="6">
          <div class="font-weight-bold">
            {{ shelter.name }}
          </div>
          <div class="text-caption mt-2 grey--text" style="text-align: left">
            {{ shelter.address }}
          </div>
        </v-col>
        <v-col cols="6">
          <v-row no-gutters>
            <v-col v-for="item in items" :key="item.id" cols="3">
              <div v-if="item.is_selected" class="text-caption text-center ml-1 mt-1" style="background-color: #DFEEE5;">{{ item.type }}</div>
              <div v-else class="text-caption grey--text text-center ml-1 mt-1" style="background-color: #DFEEE5; opacity: 0.4;">{{ item.type }}</div>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-card-text>
  </BaseCard>
</template>

<script>
import BaseCard from '~/components/molecules/cards/BaseCard.vue'

export default {
  name: 'ShelterListCardText',

  components: {
    BaseCard
  },

  props: {
    shelter: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      items: [
        { id: 1, type: '洪水', is_selected: this.shelter.flood },
        { id: 2, type: '土砂災害', is_selected: this.shelter.landslide },
        { id: 3, type: '高潮', is_selected: this.shelter.storm_surge },
        { id: 4, type: '地震', is_selected: this.shelter.earthquake },
        { id: 5, type: '津波', is_selected: this.shelter.tsunami },
        { id: 6, type: '火事', is_selected: this.shelter.fire },
        { id: 7, type: '内水氾濫', is_selected: this.shelter.inland_flood },
        { id: 8, type: '火山噴火', is_selected: this.shelter.volcano }
      ]
    }
  }
}
</script>
