<template>
  <div>
    <v-card-subtitle>ジャンル選択</v-card-subtitle>
    <ValidationProvider v-slot="{ errors }" name="genre" rules="required">
      <v-row>
        <v-col v-for="genre in genres" :key="genre.id" cols="4" md="3" style="height: 35px;">
          <v-checkbox
            v-model="valueModel"
            :value="genre.id"
            :label="genre.name"
            color="#ef5350"
            dense
            :error-messages="errors"
          />
        </v-col>
      </v-row>
    </ValidationProvider>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Array,
      default: () => []
    }
  },
  data () {
    return {
      genres: []
    }
  },
  computed: {
    valueModel: {
      get () {
        return this.value
      },
      set (newVal) {
        return this.$emit('input', newVal)
      }
    }
  },
  created () {
    this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.genres = response.data.genres
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
  }
}
</script>
