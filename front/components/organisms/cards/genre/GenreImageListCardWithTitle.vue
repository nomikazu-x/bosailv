<template>
  <div>
    <BaseTitleCard v-if="genres != null" class="mt-5" title="ジャンル一覧" />
    <GenreImageListCard
      :genres="genres"
      class="mt-1"
    />
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import GenreImageListCard from '~/components/organisms/cards/genre/GenreImageListCard.vue'

export default {
  name: 'GenreImageListCardWithTitle',

  components: {
    BaseTitleCard,
    GenreImageListCard
  },

  mixins: [Application],
  data () {
    return {
      genres: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.genres = null
        } else {
          this.genres = response.data.genres
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

    this.processing = false
  }
}
</script>
