<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard title="ジャンル作成" />
      <GenreNewForm
        :processing="processing"
        @genre-create="onGenreCreate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import GenreNewForm from '~/components/organisms/form/GenreNewForm.vue'

export default {
  name: 'GenreNewCard',

  components: {
    BaseTitleCard,
    GenreNewForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },
  created () {
    this.processing = false
  },

  methods: {
    async onGenreCreate (genreInfo) {
      this.processing = true

      const params = new FormData()
      params.append('genre[name]', genreInfo.name)
      params.append('genre[image]', genreInfo.image)
      params.append('genre[icon]', genreInfo.icon)
      params.append('genre[description]', genreInfo.description)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminGenreCreateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
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
