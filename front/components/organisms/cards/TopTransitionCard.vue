<template>
  <div>
    <BaseTitleCard title="探す" />
    <v-row class="mt-1 mb-5" align="center" justify="center" no-gutters>
      <v-col v-for="item in items" :key="item.id" :cols="item.cols">
        <BaseCard :to="item.to" class="ma-1">
          <div class="text-center">
            <v-icon color="#117768" class="mt-3" size="50">{{ item.icon }}</v-icon>
            <v-card-title class="justify-center">{{ item.title }}</v-card-title>
          </div>
        </BaseCard>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import BaseCard from '~/components/molecules/cards/BaseCard.vue'

export default {
  name: 'TopTransitionCard',

  components: {
    BaseTitleCard,
    BaseCard
  },

  data () {
    return {
      items: [
        { id: 1, title: '避難所', to: '/shelters', icon: 'mdi-exit-run', cols: '6' },
        { id: 2, title: 'ハザードマップ', to: '/hazard_maps', icon: 'mdi-book-multiple', cols: '6' },
        { id: 3, title: '記事検索', to: '/articles/search', icon: 'mdi-pencil-box-multiple', cols: '6' },
        { id: 4, title: '緊急時連絡先', to: '/emergency_contacts', icon: 'mdi-phone-in-talk', cols: '6' }
      ]
    }
  }
}
</script>
