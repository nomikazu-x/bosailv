<template>
  <BaseTitleCard class="mt-3" title="関連するジャンル">
    <v-card-text v-if="genres.length > 0">
      <v-chip-group
        active-class="primary--text"
        column
      >
        <v-chip
          v-for="genre in genres"
          :key="genre.id"
          color="#117768"
          outlined
          small
        >
          <nuxt-link
            :to="{ path: `/genres/${genre.id}` }"
            style="color: inherit; text-decoration: none;"
          >
            {{ genre.name }}
          </nuxt-link>
        </v-chip>
      </v-chip-group>
    </v-card-text>
    <v-card-text v-else>
      関連するジャンルはありません。
    </v-card-text>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'

export default {
  components: {
    BaseTitleCard
  },

  props: {
    genres: {
      type: Array,
      default: () => []
    }
  }
}
</script>
