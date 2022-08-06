<template>
  <BaseCard :to="{ name: 'shelters-id___ja', params: { id: shelter.id }}" class="my-2">
    <v-card-text class="black--text">
      <v-row>
        <v-col cols="12">
          <v-card-title class="font-weight-bold">
            {{ shelter.name }}
          </v-card-title>
        </v-col>
        <v-col cols="12">
          <v-card-text>
            {{ shelter.address }}
          </v-card-text>
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
  }
}
</script>
