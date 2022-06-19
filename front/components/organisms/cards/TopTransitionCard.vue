<template>
  <BaseTitleCard class="mb-5" title="探す">
    <v-card class="py-9 px-5" height="100">
      <v-row justify="space-around">
        <BaseBtn>ジャンル別</BaseBtn>
        <BaseBtn>避難所</BaseBtn>
        <BaseBtn>ハザードマップ</BaseBtn>
        <BaseBtn>おすすめ</BaseBtn>
      </v-row>
    </v-card>
  </BaseTitleCard>
</template>

<script>
export default {
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
