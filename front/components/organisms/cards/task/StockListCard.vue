<template>
  <BaseTitleCard v-if="stocks !== null" title="備蓄品リスト">
    <TheProcessing v-if="processing" />
    <v-card v-for="stock in stocks" :key="stock.id" class="my-3" tile>
      <v-row align="center">
        <v-col cols="6">
          <v-card-subtitle>
            {{ stock.name }}
          </v-card-subtitle>
        </v-col>
        <v-col cols="3">
          <v-card-subtitle>
            {{ stock.count }}
          </v-card-subtitle>
        </v-col>
        <v-col cols="3">
          <v-card-subtitle>
            {{ stock.name }}
          </v-card-subtitle>
        </v-col>
        <!-- <v-col cols="4">
          <div class="text-center">
            <CompleteBtnGroup
              v-if="$auth.loggedIn"
              :task="task"
              @complete="onComplete(task.value)"
              @un-complete="onUnComplete(task.value)"
            />
          </div>
        </v-col> -->
      </v-row>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
// import CompleteBtnGroup from '~/components/organisms/btnGroup/CompleteBtnGroup.vue'

export default {
  name: 'StockListCard',

  components: {
    BaseTitleCard
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
  }
}
</script>
