<template>
  <BaseTitleCard v-if="stocks !== null" title="備蓄品リスト">
    <TheProcessing v-if="processing" />
    <v-card v-for="stock in stocks" :key="stock.id" class="my-3" tile>
      <v-row v-if="stock.count !== 0" align="center">
        <v-col cols="7">
          <v-card-subtitle>
            {{ stock.name }}
          </v-card-subtitle>
        </v-col>
        <v-col cols="2">
          <v-card-subtitle>
            {{ stock.count }}
          </v-card-subtitle>
        </v-col>
        <v-col cols="3">
          <div class="text-center">
            <CompleteBtnGroup
              v-if="$auth.loggedIn"
              :task="stock"
              @complete="onComplete(stock.value)"
              @un-complete="onUnComplete(stock.value)"
            />
          </div>
        </v-col>
      </v-row>
    </v-card>
    <div class="text-center mt-5 mb-3">
      <GreenBtn to="/tasks/stocks/edit" text>あなたの家族情報を編集する</GreenBtn>
    </div>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import CompleteBtnGroup from '~/components/organisms/btnGroup/CompleteBtnGroup.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'StockListCard',

  components: {
    BaseTitleCard,
    CompleteBtnGroup,
    GreenBtn
  },

  mixins: [Application],

  data () {
    return {
      stocks: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.stocksUrl)
      .then((response) => {
        if (response.data == null || response.data.stocks == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.stocks = response.data.stocks
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
        return this.$router.push({ path: '/' })
      })
    this.processing = false
  },

  methods: {
    async onComplete (task) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.taskProfileUpdateUrl, {
        stock_task: task
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setLevel', response.data.user.level, { root: true })
            this.$auth.setUser(response.data.user)
            this.$toasted.success(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    },

    async onUnComplete (task) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.taskProfileDeleteUrl, {
        stock_task: task
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$auth.setUser(response.data.user)
            this.$toasted.success(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
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
