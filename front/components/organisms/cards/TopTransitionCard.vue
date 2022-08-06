<template>
  <BaseTitleCard class="mb-5" title="探す">
    <v-card class="py-9 px-5" height="100">
      <v-row justify="space-around">
        <BaseBtn to="/genres">ジャンル別</BaseBtn>
        <BaseBtn to="/shelters">避難所</BaseBtn>
        <BaseBtn to="/hazard_maps">ハザードマップ</BaseBtn>
        <BaseBtn>おすすめ</BaseBtn>
      </v-row>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import BaseBtn from '~/components/molecules/btns/BaseBtn.vue'

export default {
  name: 'TopTransitonCard',

  components: {
    BaseTitleCard,
    BaseBtn
  },

  data () {
    return {
      items: [
        { title: 'ジャンル別', to: '/genres' },
        { title: 'ランキング', to: '/articles/ranking' }
      ]
    }
  }
}
</script>
