<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8">
      <TheMessage :alert="alert" :notice="notice" />
      <BaseTitleCard title="家族構成の情報">
        <div class="pa-5">
          <article v-if="families !== null && families.length === 0">
            <v-card-text>家族構成情報が登録されていません。</v-card-text>
            <v-divider class="my-4" />
          </article>
          <FamilyListCardText v-for="family in families" :key="family.id" :family="family" />
          <FamilyEditForm v-if="$auth.loggedIn" @alert="alert = $event" @notice="notice = $event" />
        </div>

        <v-divider />
        <div class="text-center mt-5 mb-3">
          <GreenBtn to="/stocks" text>備蓄品リストを確認する</GreenBtn>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from 'vuex'
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import FamilyListCardText from '~/components/organisms/cardText/FamilyListCardText.vue'
import FamilyEditForm from '~/components/organisms/form/FamilyEditForm.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'FamilyEditCard',

  components: {
    BaseTitleCard,
    FamilyListCardText,
    FamilyEditForm,
    GreenBtn
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },

  computed: {
    ...mapGetters({
      families: 'families/families'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.familiesUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.$store.commit('families/setFamilies', response.data.families, { root: true })
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
