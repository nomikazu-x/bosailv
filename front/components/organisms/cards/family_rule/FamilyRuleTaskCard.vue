<template>
  <BaseTitleCard v-if="familyRule !== null" title="家族会議メモ" outlined tile>
    <TheProcessing v-if="processing" />
    <v-col cols="12">
      <v-card-text>
        <div class="main-heading font-weight-bold" style="color: #117768;">非常時の連絡方法</div>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div class="mx-2 my-2" v-html="familyRule.contact_means_memo" />
      </v-card-text>
      <v-card-text>
        <div class="main-heading font-weight-bold" style="color: #117768;">避難場所のルート</div>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div class="mx-2 my-2" v-html="familyRule.refuge_memo" />
      </v-card-text>
      <v-card-text>
        <div class="main-heading font-weight-bold" style="color: #117768;">地震直後の家族の分担</div>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div class="mx-2 my-2" v-html="familyRule.family_role_memo" />
      </v-card-text>
      <v-card-text>
        <div class="main-heading font-weight-bold" style="color: #117768;">誰かが下敷きになったら</div>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div class="mx-2 my-2" v-html="familyRule.emergency_measure_memo" />
      </v-card-text>
      <v-card-text>
        <div class="main-heading font-weight-bold" style="color: #117768;">家を離れるときにすること</div>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div class="mx-2 my-2" v-html="familyRule.leave_home_memo" />
      </v-card-text>
      <v-divider class="my-5" />
      <div class="text-center">
        <OrangeBtn to="family_rule/edit">編集する</OrangeBtn>
        <DeleteConfirmDialog name="リセット" title="家族会議のメモをリセット" @click="onFamilyRuleDelete" />
      </div>
    </v-col>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'FamilyRuleTaskCard',

  components: {
    OrangeBtn,
    BaseTitleCard,
    DeleteConfirmDialog
  },

  mixins: [Application],

  data () {
    return {
      familyRule: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.familyRuleUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
        } else {
          this.familyRule = response.data.family_rule
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
        return this.$router.push({ path: '/home' })
      })

    this.processing = false
  },

  methods: {
    async onFamilyRuleDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.familyRuleDeleteUrl)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.setUser(response.data.user)
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            this.$router.push({ path: '/family_rule/edit' })
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
