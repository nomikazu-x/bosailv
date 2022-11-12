<template>
  <v-dialog transition="dialog-top-transition" max-width="600px">
    <template #activator="{ on, attrs }">
      <v-btn text rounded exact v-bind="attrs" v-on="on">
        <v-icon color="amber" large>mdi-file-powerpoint-box</v-icon>
        <div class="hidden-sm-and-down">ポイントについて</div>
      </v-btn>
    </template>
    <template #default="dialog">
      <v-card justify="center" align="center">
        <v-card-title>ポイント獲得方法</v-card-title>
        <v-data-table
          :headers="headers"
          :items="items"
          hide-default-footer
        >
          <template #[`item.operation`]="{ item }">
            <NuxtLink
              :to="item.to"
              class="text-decoration-none green--text text--darken-1"
              @click.native="dialog.value = false"
            >
              {{ item.operation }}
              <v-icon small color="green darken-1">mdi-chevron-right</v-icon>
            </NuxtLink>
          </template>
          <template #[`item.obtainPoint`]="{ item }">
            <v-chip
              :color="getColor(item.obtainPoint)"
              dark
            >
              {{ item.obtainPoint }}
            </v-chip>
          </template>
        </v-data-table>

        <div class="text-caption font-weight-light text-left ml-2">※獲得した防災ポイントは、本アプリ内の防災レベルを上げるためにしか使用できません。</div>

        <v-card-actions>
          <v-spacer />
          <v-btn
            color="green darken-1"
            text
            @click="dialog.value = false"
          >
            閉じる
          </v-btn>
        </v-card-actions>
      </v-card>
    </template>
  </v-dialog>
</template>

<script>
export default {
  data () {
    return {
      headers: [
        { text: '防災タスク', value: 'operation' },
        { text: '獲得ポイント', value: 'obtainPoint' }
      ],
      items: [
        { operation: 'ハザードマップ確認', obtainPoint: 5, to: '/hazard_maps' },
        { operation: 'マイ避難所登録', obtainPoint: 5, to: '/shelters' },
        { operation: '各防災SNSアカウントフォロー', obtainPoint: 1, to: '/sns_tasks' },
        { operation: '各おうち防災タスク達成', obtainPoint: 1, to: '/house_tasks' },
        { operation: '家族会議メモ作成', obtainPoint: 5, to: '/family_rule' },
        { operation: '緊急時連絡先登録', obtainPoint: 5, to: '/emergency_contacts' },
        { operation: '各備蓄品を備蓄', obtainPoint: 1, to: '/stocks' },
        { operation: '災害時役立つ記事を作成', obtainPoint: 5, to: '/articles/new' },
        { operation: '災害時役立つ記事をお気に入りする', obtainPoint: 1, to: '/articles' },
        { operation: '災害時役立つ記事をお気に入りされる', obtainPoint: 1, to: '/articles' }
      ]
    }
  },
  methods: {
    getColor (obtainPoint) {
      if (obtainPoint === 5) { return 'amber darken-3' } else { return 'amber' }
    }
  }
}
</script>
