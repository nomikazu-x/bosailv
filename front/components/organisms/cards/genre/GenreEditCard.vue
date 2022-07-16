<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8">
      <BaseTitleCard title="ジャンル編集" />
      <GenreEditForm
        :genre="genre"
        :processing="processing"
        @genre-update="onGenreUpdate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import GenreEditForm from '~/components/organisms/form/GenreEditForm.vue'

export default {
  name: 'GenreEditCard',

  components: {
    BaseTitleCard,
    GenreEditForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null,
      genre: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.genreShowUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.genre = response.data.genre
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/' })
      })

    this.processing = false
  },

  methods: {
    async onGenreUpdate (genreInfo) {
      this.processing = true

      const params = new FormData()
      params.append('genre[name]', genreInfo.name)
      params.append('genre[image]', genreInfo.image)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.genreUpdateUrl.replace('_id', this.$route.params.id), params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.$router.push({ path: '/admin/genres' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
